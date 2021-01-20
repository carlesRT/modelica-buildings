within Buildings.Experimental.Templates.AHUs.Main;
model VAVSingleDuct "VAV single duct with relief"
  extends Interfaces.Main(
    final typ=Types.Main.SupplyReturn,
    final typSup=Types.Supply.SingleDuct,
    final typRet=Types.Return.WithRelief);

  final constant Types.Economizer typEco = eco.typ
    "Type of economizer"
    annotation (Evaluate=true,
      Dialog(group="Economizer"));
  final constant Types.Coil typCoiCoo = coiCoo.typ
    "Type of cooling coil"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final constant Types.Actuator typActCoiCoo = coiCoo.typAct
    "Type of cooling coil actuator"
    annotation (Evaluate=true,
      Dialog(group="Cooling coil"));
  final constant Types.Fan typFanSup = if fanSupDra.typ<>Types.Fan.None then
    fanSupDra.typ else fanSupBlo.typ
    "Type of supply fan"
    annotation (Evaluate=true,
      Dialog(group="Supply fan"));
  final constant Boolean have_souCoiCoo = coiCoo.have_sou
    "Set to true for fluid ports on the source side"
    annotation (Evaluate=true, Dialog(group="Cooling coil"));
  parameter Boolean have_draThr = true
    "Set to true for a draw-through fan, false for a blow-through fan"
    annotation (Evaluate=true, Dialog(group="Supply fan"));

  inner replaceable parameter Economizers.Data.None datEco
    constrainedby Economizers.Data.None
    "Economizer data"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typEco<>Types.Economizer.None,
        group="Economizer"),
      __Linkage(
        select(
          condition=typEco==Types.Economizer.DedicatedDamperTandem,
          redeclare parameter Economizers.Data.None datEco)));

  /*
  We need a variable for the record type in order to support the 
  redeclaration when instantiating the coil model.
  Note:
  - The final assignments of structural parameters must be done here
  (and not in Interfaces.Coil) so that they are not rendered in the UI
  when the class is instantiated.
  - There is no component visible in the diagram layer.
  */
  replaceable record RecordCoiCoo = Coils.Data.None
    constrainedby Coils.Data.None(
      final typAct=coiCoo.typAct,
      final typHex=coiCoo.typHex)
    "Cooling coil data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typCoiCoo<>Types.Coil.None,
        group="Cooling coil"));
  /* 
  The following declaration is not needed: we only propagate the record type.
  The parameter propagation is done through the parameter modification 
  within the type redeclaration.
  */
  /*
  replaceable parameter RecordCoiCoo datCoiCoo
    "Cooling coil data"
    annotation (
    Placement(transformation(extent={{-40,-150},{-20,-130}})),
    Dialog(enable=false));
  */

  replaceable record RecordFanSup = Fans.Data.None
    constrainedby Fans.Data.None
    "Supply fan data record"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})),
      choicesAllMatching=true,
      Dialog(
        enable=typFanSup<>Types.Fan.None,
        group="Supply fan"));


  Modelica.Fluid.Interfaces.FluidPort_a port_OutMin(
    redeclare package Medium = MediumAir) if
    typEco==Types.Economizer.DedicatedDamperTandem
    "Minimum outdoor air intake"
    annotation (Placement(transformation(extent={{-310,
            -150},{-290,-130}}), iconTransformation(extent={{-210,-10},{-190,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_coiCooRet(
    redeclare package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil return port"
    annotation (Placement(
      transformation(extent={{10,-290},{30,-270}}),
      iconTransformation(extent={{10,-210},{30,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_coiCooSup(
    redeclare package Medium = MediumCoo) if have_souCoiCoo
    "Cooling coil supply port"
    annotation (Placement(
        transformation(extent={{-30,-290},{-10,-270}}), iconTransformation(
          extent={{-30,-210},{-10,-190}})));

  BoundaryConditions.WeatherData.Bus weaBus if
    coiCoo.typ == Types.Coil.DXVariableSpeed or
    coiCoo.typ == Types.Coil.DXMultiStage
    annotation (Placement(
        transformation(extent={{-20,240},{20,280}}), iconTransformation(extent={{-20,182},
            {20,218}})));

  replaceable Economizers.None eco
    constrainedby Interfaces.Economizer(
      redeclare final package Medium = MediumAir)
    "Economizer"
    annotation (
      choices(
        choice(redeclare replaceable Economizers.None eco
          "No economizer"),
        choice(redeclare replaceable Economizers.CommonDamperTandem eco
          "Single common OA damper - Dampers actuated in tandem"),
        choice(redeclare replaceable Economizers.CommonDamperFree  eco
          "Single common OA damper - Dampers actuated individually"),
        choice(redeclare replaceable Economizers.DedicatedDamperTandem eco
          "Separate dedicated OA damper - Dampers actuated in tandem")),
      Dialog(group="Economizer"),
      __Linkage(
        choicesConditional(
          condition=typRet==Types.Return.NoRelief,
          choices(
            choice(redeclare replaceable Economizers.None eco
              "No economizer"),
            choice(redeclare replaceable Economizers.CommonDamperTandem eco
              "Single common OA damper - Dampers actuated in tandem"),
            choice(redeclare replaceable Economizers.CommonDamperFree  eco
              "Single common OA damper - Dampers actuated individually"),
            choice(redeclare replaceable Economizers.DedicatedDamperTandem eco
              "Separate dedicated OA damper - Dampers actuated in tandem")),
          condition=typRet==Types.Return.NoRelief,
          choices(
            choice(redeclare replaceable Economizers.None eco
              "No economizer"),
            choice(redeclare replaceable Economizers.CommonDamperFreeNoRelief eco
              "Single common OA damper - Dampers actuated individually, no relief")))),
      Placement(transformation(extent={{-230,-150},{-210,-130}})));

  replaceable Coils.None coiCoo
    constrainedby Interfaces.Coil(
      final fun=Types.CoilFunction.Cooling,
      redeclare final RecordCoiCoo datCoi,
      redeclare final package MediumAir = MediumAir,
      redeclare final package MediumSou = MediumCoo)
    "Cooling coil"
    annotation (
    choicesAllMatching=true,
    Dialog(group="Cooling coil"),
    Placement(transformation(extent={{-10,-210},{10,-190}})));

  replaceable Fans.None fanSupBlo
    constrainedby Interfaces.Fan(
      final fun=Types.FanFunction.Supply,
      redeclare final RecordFanSup dat,
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Blow through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=not have_draThr),
    Placement(transformation(extent={{-120,-210},{-100,-190}})));

  replaceable Fans.None fanSupDra
    constrainedby Interfaces.Fan(
      final fun=Types.FanFunction.Supply,
      redeclare final RecordFanSup dat,
      redeclare final package MediumAir = MediumAir)
    "Supply fan - Draw through"
    annotation (
    choicesAllMatching=true,
    Dialog(
      group="Supply fan",
      enable=have_draThr),
    Placement(transformation(extent={{80,-210},{100,-190}})));


  // FIXME: Dummy default values fo testing purposes only.
  Fluid.FixedResistances.PressureDrop resRet(
    redeclare package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{262,-90},{242,-70}})));
  Fluid.FixedResistances.PressureDrop resSup(
    redeclare package Medium = MediumAir,
    m_flow_nominal=1,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{242,-210},{262,-190}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoOut(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-240,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoRet(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-200,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yEcoExh(k=1)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-160,110})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yCoiCooVar(k=1) if
       typCoiCoo==Types.Coil.WaterBased or
       typCoiCoo==Types.Coil.DXVariableSpeed
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-100,110})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant yCoiCooSta(k=1) if
       typCoiCoo==Types.Coil.DXMultiStage
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-60,110})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yFanSupVar(k=1) if
       typFanSup==Types.Fan.SingleVariable annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant yFanSupCst(k=true) if
       typFanSup==Types.Fan.SingleConstant annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,110})));
equation
  // Non graphical connections - START
  connect(yCoiCooVar.y, ahuBus.ahuO.yCoiCoo);
  connect(yFanSupCst.y, ahuBus.ahuO.yFanSup);
  // Non graphical connections - STOP
  connect(port_OutMin, eco.port_OutMin)
    annotation (Line(points={{-300,-140},{-230,-140}}, color={0,127,255}));
  connect(port_Exh, eco.port_Exh) annotation (Line(points={{-300,-80},{-240,
          -80},{-240,-133},{-230,-133}},
                                    color={0,127,255}));
  connect(port_Out, eco.port_Out) annotation (Line(points={{-300,-200},{-240,
          -200},{-240,-147},{-230,-147}},
                                    color={0,127,255}));
  connect(port_coiCooSup, coiCoo.port_aSou) annotation (Line(points={{-20,-280},
          {-20,-220},{-4,-220},{-4,-210}}, color={0,127,255}));
  connect(coiCoo.port_bSou, port_coiCooRet) annotation (Line(points={{4,-210},{4,
          -220},{20,-220},{20,-280}}, color={0,127,255}));

  connect(resSup.port_b, port_Sup)
    annotation (Line(points={{262,-200},{300,-200}}, color={0,127,255}));
  connect(eco.port_Ret, resRet.port_b) annotation (Line(points={{-210,-132.8},
          {-200,-132.8},{-200,-80},{242,-80}},
                                         color={0,127,255}));
  connect(resRet.port_a, port_Ret)
    annotation (Line(points={{262,-80},{300,-80}}, color={0,127,255}));
  connect(ahuBus, eco.ahuBus) annotation (Line(
      points={{-300,0},{-220,0},{-220,-130},{-220,-130}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, coiCoo.weaBus) annotation (Line(
      points={{0,260},{0,80},{6,80},{6,-190},{5,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, coiCoo.ahuBus) annotation (Line(
      points={{-300,0},{0,0},{0,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(yEcoOut.y, ahuBus.ahuO.yEcoOut) annotation (Line(points={{-240,98},{-240,
          0.1},{-300.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yEcoRet.y, ahuBus.ahuO.yEcoRet) annotation (Line(points={{-200,98},{-200,
          0.1},{-300.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(yEcoExh.y, ahuBus.ahuO.yEcoExh) annotation (Line(points={{-160,98},{-160,
          0.1},{-300.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(yCoiCooSta.y, ahuBus.ahuO.yCoiCoo) annotation (Line(points={{-60,98},{
          -60,0.1},{-300.1,0.1}}, color={255,127,0}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(eco.port_Sup, fanSupBlo.port_a) annotation (Line(points={{-210,-147},{
          -200,-147},{-200,-200},{-120,-200}}, color={0,127,255}));
  connect(fanSupBlo.port_b, coiCoo.port_a)
    annotation (Line(points={{-100,-200},{-10,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, fanSupDra.port_a)
    annotation (Line(points={{10,-200},{80,-200}}, color={0,127,255}));
  connect(fanSupDra.port_b, resSup.port_a)
    annotation (Line(points={{100,-200},{242,-200}}, color={0,127,255}));
  connect(yFanSupVar.y, ahuBus.ahuO.yFanSup) annotation (Line(points={{60,98},{60,
          0},{-120,0},{-120,0.1},{-300.1,0.1}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ahuBus, fanSupBlo.ahuBus) annotation (Line(
      points={{-300,0},{-110,0},{-110,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(ahuBus, fanSupDra.ahuBus) annotation (Line(
      points={{-300,0},{90,0},{90,-190}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="ahu",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
    coordinateSystem(preserveAspectRatio=false)));
end VAVSingleDuct;