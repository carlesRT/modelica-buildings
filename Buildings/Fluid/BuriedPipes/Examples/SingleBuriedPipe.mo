﻿within Buildings.Fluid.BuriedPipes.Examples;
model SingleBuriedPipe "Example model of a single buried pipe"
  extends Modelica.Icons.Example;

  replaceable parameter Buildings.BoundaryConditions.GroundTemperature.ClimaticConstants.Boston cliCon "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(k=1.58,c=1150,d=1600) "Soil thermal properties";
  replaceable package Medium = Buildings.Media.Water "Medium in the pipe" annotation (
      choicesAllMatching=true);

  FixedResistances.PlugFlowPipe pip(
    redeclare package Medium=Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    nPorts=1) "Buried pipe"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Fluid.BuriedPipes.GroundCoupling gro(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    len=1000,
    dep={1.5},
    pos={0},
    rad={0.05 + 0.032 + 0.01}) "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,90})));

  Modelica.Blocks.Sources.Sine Tin(
    amplitude=5,
    freqHz=1/180/24/60/60,
    offset=273.15 + 20) "Pipe inlet temperature signal"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Sources.MassFlowSource_T sou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true,
    m_flow=3) "Flow source"
    annotation (Placement(transformation(extent={{-66,30},{-46,50}})));
  Sensors.TemperatureTwoPort senTemInl(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe inlet temperature sensor"
    annotation (Placement(transformation(extent={{-36,30},{-16,50}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Sensors.TemperatureTwoPort senTemOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{46,30},{66,50}})));

  FixedResistances.PlugFlowPipe pipRev(
    redeclare package Medium = Medium,
    dh=0.1,
    length=1000,
    m_flow_nominal=1,
    dIns=0.01,
    kIns=100,
    cPip=500,
    rhoPip=8000,
    thickness=0.0032,
    nPorts=1) "Buried pipe"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  GroundCoupling groRev(
    nPip=1,
    cliCon=cliCon,
    soiDat=soiDat,
    len=1000,
    dep={1.5},
    pos={0},
    rad={0.05 + 0.032 + 0.01}) "Ground coupling" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-10})));
  Sources.MassFlowSource_T souRev(
    nPorts=1,
    redeclare package Medium = Medium,
    m_flow=-3) "Flow source"
    annotation (Placement(transformation(extent={{-66,-70},{-46,-50}})));
  Sensors.TemperatureTwoPort senTemOutRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{-36,-70},{-16,-50}})));
  Sources.Boundary_pT sinRev(
    redeclare package Medium = Medium,
    use_T_in=true,
    T=273.15 + 10,
    nPorts=1,
    p(displayUnit="Pa") = 101325) "Boundary condition"
    annotation (Placement(transformation(extent={{100,-70},{80,-50}})));
  Sensors.TemperatureTwoPort senTemInlRev(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    T_start=293.15) "Pipe outlet temperature sensor"
    annotation (Placement(transformation(extent={{46,-70},{66,-50}})));
equation
  connect(Tin.y,sou. T_in)
    annotation (Line(points={{-89,-40},{-80,-40},{-80,44},{-68,44}},
                                               color={0,0,127}));
  connect(sou.ports[1], senTemInl.port_a)
    annotation (Line(points={{-46,40},{-36,40}}, color={0,127,255}));
  connect(senTemOut.port_b, sin.ports[1])
    annotation (Line(points={{66,40},{80,40}},
                                             color={0,127,255}));
  connect(senTemInl.port_b, pip.port_a)
    annotation (Line(points={{-16,40},{0,40}}, color={0,127,255}));
  connect(pip.ports_b[1], senTemOut.port_a)
    annotation (Line(points={{20,40},{46,40}},
                                             color={0,127,255}));
  connect(pip.heatPort, gro.ports[1]) annotation (Line(points={{10,50},{10,80}},
                           color={191,0,0}));
  connect(souRev.ports[1], senTemOutRev.port_a)
    annotation (Line(points={{-46,-60},{-36,-60}}, color={0,127,255}));
  connect(senTemInlRev.port_b, sinRev.ports[1])
    annotation (Line(points={{66,-60},{80,-60}}, color={0,127,255}));
  connect(senTemOutRev.port_b, pipRev.port_a)
    annotation (Line(points={{-16,-60},{0,-60}}, color={0,127,255}));
  connect(pipRev.ports_b[1], senTemInlRev.port_a)
    annotation (Line(points={{20,-60},{46,-60}}, color={0,127,255}));
  connect(pipRev.heatPort, groRev.ports[1])
    annotation (Line(points={{10,-50},{10,-20}}, color={191,0,0}));
  connect(Tin.y, sinRev.T_in) annotation (Line(points={{-89,-40},{110,-40},{110,
          -56},{102,-56}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
    experiment(
      StopTime=63072000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
This example showcases the ground thermal coupling for a single uninsulated 
buried pipe operating around ambient temperature (<i>20</i>°C).
Both design flow direction and reverse flow direction 
(components with suffix <code>Rev</code>) are simulated.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/BuriedPipes/Examples/SingleBuriedPipe.mos"
        "Simulate and plot"));
end SingleBuriedPipe;