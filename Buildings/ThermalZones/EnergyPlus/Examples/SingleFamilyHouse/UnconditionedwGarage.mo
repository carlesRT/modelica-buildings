within Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse;
model UnconditionedwGarage
  "Example model with two unconditoned zone simulated in Modelica, and the unconditioned attic simulated in EnergyPlus"
  extends Unconditioned;

  ThermalZone garage(
    redeclare package Medium = Medium,
    zoneName="GARAGE ZONE",
    nPorts=2) "Thermal zone"
    annotation (Placement(transformation(extent={{0,80},{40,120}})));
  Modelica.Blocks.Sources.Constant qIntGaiGar[3](each k=0)
    "Internal heat gains, set to zero because these are modelled in EnergyPlus"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Fluid.Sources.Boundary_pT freshAirGar(redeclare package Medium = Medium,
      nPorts=1) "Boundary condition for garage zone"
    annotation (Placement(transformation(extent={{-60,54},{-40,74}})));
  Fluid.FixedResistances.PressureDrop ducGar(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=m_flow_nominal)
    "Duct resistance to garage (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-10,54},{-30,74}})));
  Fluid.Sources.MassFlowSource_WeatherData bouGar(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=m_flow_nominal) "Boundary condition for Garage Zone"
    annotation (Placement(transformation(extent={{-60,26},{-40,46}})));
equation
  connect(qIntGaiGar.y, garage.qGai_flow)
    annotation (Line(points={{-39,110},{-2,110}},
                                              color={0,0,127}));
  connect(freshAirGar.ports[1], ducGar.port_b)
    annotation (Line(points={{-40,64},{-30,64}}, color={0,127,255}));
  connect(ducGar.port_a, garage.ports[1])
    annotation (Line(points={{-10,64},{18,64},{18,80.9}}, color={0,127,255}));
  connect(bouGar.ports[1], garage.ports[2])
    annotation (Line(points={{-40,36},{22,36},{22,80.9}}, color={0,127,255}));
  connect(building.weaBus, bouGar.weaBus) annotation (Line(
      points={{-60,-80},{-60,36.2},{-60,36.2}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    Documentation(
      info="<html>
<p>
This example models the living room as an unconditioned zone in Modelica.
The living room is connected to a fresh air supply and exhaust.
The heat balance of the air of the other two thermal zones, i.e.,
the attic and the garage, are modeled in EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Examples/SingleFamilyHouse/Unconditioned.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-100},{100,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,140}})));
end UnconditionedwGarage;
