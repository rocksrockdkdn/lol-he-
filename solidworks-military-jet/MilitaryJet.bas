' ============================================================================
' MilitaryJet.bas - SolidWorks VBA macro
'
' Builds a parametric single-seat fighter jet (F-16 style, ~15 m long) as a
' native SolidWorks part:
'   1. Fuselage      - revolved boss from a side profile
'   2. Delta wings   - mid-plane extrusion on the Top plane
'   3. Horizontal stabilizers - mid-plane extrusion on the Top plane
'   4. Vertical tail fin      - mid-plane extrusion on the Front plane
'   5. Canopy        - mid-plane extrusion on the Front plane
'
' HOW TO RUN
'   1. Open SolidWorks (2018 or newer, English UI - the macro selects the
'      default reference planes by their English names "Front Plane" /
'      "Top Plane").
'   2. Tools > Macro > New...  (save as MilitaryJet.swp), then in the VBA
'      editor replace the contents of the module with this file
'      (or File > Import File... and pick MilitaryJet.bas).
'   3. Press F5 (Run). A new part is created and the jet is modeled.
'
' All dimensions are in metres (the SolidWorks API always works in metres).
' Edit the constants below to reshape the aircraft, then re-run.
' ============================================================================
Option Explicit

' ---- overall dimensions (metres) -------------------------------------------
Const FUSELAGE_LENGTH As Double = 15#      ' nose to tail
Const FUSELAGE_RADIUS As Double = 0.8      ' max body radius
Const WING_SPAN As Double = 4.6            ' half-span from centreline
Const WING_THICKNESS As Double = 0.12
Const STAB_SPAN As Double = 2.4            ' horizontal stabilizer half-span
Const STAB_THICKNESS As Double = 0.09
Const FIN_HEIGHT As Double = 3#            ' vertical tail height above body
Const FIN_THICKNESS As Double = 0.12
Const CANOPY_WIDTH As Double = 0.7

Dim swApp As Object                        ' SldWorks.SldWorks
Dim swModel As Object                      ' SldWorks.ModelDoc2
Dim swSketchMgr As Object                  ' SldWorks.SketchManager
Dim swFeatMgr As Object                    ' SldWorks.FeatureManager

Sub main()
    Set swApp = Application.SldWorks

    ' New part from the default part template
    Dim partTemplate As String
    partTemplate = swApp.GetUserPreferenceStringValue(8) ' swDefaultTemplatePart
    Set swModel = swApp.NewDocument(partTemplate, 0, 0, 0)
    If swModel Is Nothing Then
        MsgBox "Could not create a new part. Set a default part template in " & _
               "Tools > Options > Default Templates and run the macro again."
        Exit Sub
    End If

    Set swSketchMgr = swModel.SketchManager
    Set swFeatMgr = swModel.FeatureManager

    BuildFuselage
    BuildWings
    BuildStabilizers
    BuildTailFin
    BuildCanopy

    swModel.ShowNamedView2 "*Isometric", 7
    swModel.ViewZoomtofit2
    MsgBox "Military jet complete. Add fillets / appearances as desired."
End Sub

' ---------------------------------------------------------------------------
' 1. Fuselage: closed half-profile on the Front plane revolved 360 degrees
'    about a sketch centreline lying on the X axis.
' ---------------------------------------------------------------------------
Private Sub BuildFuselage()
    SelectPlane "Front Plane"
    swSketchMgr.InsertSketch True

    ' revolve axis
    swSketchMgr.CreateCenterLine 0, 0, 0, FUSELAGE_LENGTH, 0, 0

    ' half profile: nose -> canopy deck -> max section -> boat tail -> nozzle
    swSketchMgr.CreateLine 0, 0, 0, 1.5, 0.45, 0
    swSketchMgr.CreateLine 1.5, 0.45, 0, 6#, FUSELAGE_RADIUS, 0
    swSketchMgr.CreateLine 6#, FUSELAGE_RADIUS, 0, 11#, FUSELAGE_RADIUS, 0
    swSketchMgr.CreateLine 11#, FUSELAGE_RADIUS, 0, FUSELAGE_LENGTH, 0.5, 0
    swSketchMgr.CreateLine FUSELAGE_LENGTH, 0.5, 0, FUSELAGE_LENGTH, 0, 0
    swSketchMgr.CreateLine FUSELAGE_LENGTH, 0, 0, 0, 0, 0

    swModel.ClearSelection2 True
    ' single centreline in the sketch -> auto-selected as the revolve axis
    swFeatMgr.FeatureRevolve2 True, True, False, False, False, False, 0, 0, _
        6.28318530717959, 0, False, False, 0.01, 0.01, 0, 0, 0, True, True, True
    swSketchMgr.InsertSketch True
    swModel.ClearSelection2 True
End Sub

' ---------------------------------------------------------------------------
' 2. Delta wings: full-span planform sketched on the Top plane and extruded
'    symmetrically (mid-plane) through the fuselage.
' ---------------------------------------------------------------------------
Private Sub BuildWings()
    SelectPlane "Top Plane"
    swSketchMgr.InsertSketch True

    ' apex -> right tip leading edge -> right tip -> trailing edge -> left tip
    swSketchMgr.CreateLine 5.8, 0, 0, 9.9, WING_SPAN, 0
    swSketchMgr.CreateLine 9.9, WING_SPAN, 0, 10.8, WING_SPAN, 0
    swSketchMgr.CreateLine 10.8, WING_SPAN, 0, 10.8, -WING_SPAN, 0
    swSketchMgr.CreateLine 10.8, -WING_SPAN, 0, 9.9, -WING_SPAN, 0
    swSketchMgr.CreateLine 9.9, -WING_SPAN, 0, 5.8, 0, 0

    ExtrudeMidPlane WING_THICKNESS
End Sub

' ---------------------------------------------------------------------------
' 3. Horizontal stabilizers: smaller delta at the tail, Top plane.
' ---------------------------------------------------------------------------
Private Sub BuildStabilizers()
    SelectPlane "Top Plane"
    swSketchMgr.InsertSketch True

    swSketchMgr.CreateLine 11.5, 0, 0, 13.8, STAB_SPAN, 0
    swSketchMgr.CreateLine 13.8, STAB_SPAN, 0, 14.5, STAB_SPAN, 0
    swSketchMgr.CreateLine 14.5, STAB_SPAN, 0, 14.5, -STAB_SPAN, 0
    swSketchMgr.CreateLine 14.5, -STAB_SPAN, 0, 13.8, -STAB_SPAN, 0
    swSketchMgr.CreateLine 13.8, -STAB_SPAN, 0, 11.5, 0, 0

    ExtrudeMidPlane STAB_THICKNESS
End Sub

' ---------------------------------------------------------------------------
' 4. Vertical tail fin: side profile on the Front plane, thin mid-plane
'    extrusion across the centreline.
' ---------------------------------------------------------------------------
Private Sub BuildTailFin()
    SelectPlane "Front Plane"
    swSketchMgr.InsertSketch True

    swSketchMgr.CreateLine 11.2, 0.5, 0, 12.9, FIN_HEIGHT, 0
    swSketchMgr.CreateLine 12.9, FIN_HEIGHT, 0, 13.9, FIN_HEIGHT, 0
    swSketchMgr.CreateLine 13.9, FIN_HEIGHT, 0, 14.5, 0.5, 0
    swSketchMgr.CreateLine 14.5, 0.5, 0, 11.2, 0.5, 0

    ExtrudeMidPlane FIN_THICKNESS
End Sub

' ---------------------------------------------------------------------------
' 5. Canopy: simple faceted bubble over the cockpit, Front plane.
'    (Round it off afterwards with fillets if you like.)
' ---------------------------------------------------------------------------
Private Sub BuildCanopy()
    SelectPlane "Front Plane"
    swSketchMgr.InsertSketch True

    swSketchMgr.CreateLine 2.6, 0.3, 0, 3.3, 1.1, 0
    swSketchMgr.CreateLine 3.3, 1.1, 0, 5.1, 1.1, 0
    swSketchMgr.CreateLine 5.1, 1.1, 0, 6.3, 0.4, 0
    swSketchMgr.CreateLine 6.3, 0.4, 0, 2.6, 0.3, 0

    ExtrudeMidPlane CANOPY_WIDTH
End Sub

' ---------------------------------------------------------------------------
' helpers
' ---------------------------------------------------------------------------
Private Sub SelectPlane(planeName As String)
    swModel.ClearSelection2 True
    Dim ok As Boolean
    ok = swModel.Extension.SelectByID2(planeName, "PLANE", 0, 0, 0, False, 0, Nothing, 0)
    If Not ok Then
        MsgBox "Could not select '" & planeName & "'. On a non-English install, " & _
               "rename the plane constants at the top of the macro to match your UI."
        End
    End If
End Sub

' Mid-plane boss extrude of the active sketch, merged with the body.
' 6 = swEndCondMidPlane
Private Sub ExtrudeMidPlane(thickness As Double)
    swModel.ClearSelection2 True
    swFeatMgr.FeatureExtrusion2 True, False, False, 6, 0, thickness, 0#, _
        False, False, False, False, 0#, 0#, False, False, False, False, _
        True, True, True, 0, 0#, False
    swSketchMgr.InsertSketch True
    swModel.ClearSelection2 True
End Sub
