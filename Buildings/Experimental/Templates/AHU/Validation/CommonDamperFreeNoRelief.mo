within Buildings.Experimental.Templates.AHU.Validation;
model CommonDamperFreeNoRelief
  extends Modelica.Icons.Example;
  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumCoo=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Cooling medium (such as CHW)";
  Main.VAVSingleDuct ahu(redeclare Economizers.CommonDamperFreeNoRelief eco)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium=MediumAir,
    nPorts=1)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare final package Medium=MediumAir,
    nPorts=2)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Templates_V1.BaseClasses.AhuBus ahuBus
    annotation (Placement(transformation(extent={{-40,40},
            {0,80}}), iconTransformation(
          extent={{-254,122},{-234,142}})));
equation
  connect(bou.ports[1], ahu.port_Out) annotation (Line(points={{-60,0},{-40,0},
          {-40,-10},{-20,-10}},color={0,127,255}));
  connect(ahu.port_Sup, bou1.ports[1]) annotation (Line(points={{20,-10},{40,
          -10},{40,2},{60,2}},
                          color={0,127,255}));
  connect(ahu.port_Ret, bou1.ports[2]) annotation (Line(points={{20,10},{40,10},
          {40,-2},{60,-2}}, color={0,127,255}));
  connect(one.y, ahuBus.ahuO.yEcoOut) annotation (Line(points={{-58,60},{-28,60},
          {-28,60.1},{-19.9,60.1}}, color={0,0,127}));
  connect(ahuBus, ahu.ahuBus) annotation (Line(
      points={{-20,60},{-20,28},{-19.9,28},{-19.9,16}},
      color={255,204,51},
      thickness=0.5));
  connect(one.y, ahuBus.ahuO.yEcoExh) annotation (Line(points={{-58,60},{-38,60},
          {-38,60.1},{-19.9,60.1}}, color={0,0,127}));
  connect(one.y, ahuBus.ahuO.yEcoRet) annotation (Line(points={{-58,60},{-38,60},
          {-38,60.1},{-19.9,60.1}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CommonDamperFreeNoRelief;