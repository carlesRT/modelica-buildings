within Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse;
model InteriorSurfaceConduction
  "Example model with two EnergyPlus unconditioned zones with their separating surfaces modeled in Modelica"
  extends UnconditionedwGarage;

  ZoneSurface surGar(surfaceName="Garage:Interior")
    annotation (Placement(transformation(extent={{134,20},{154,40}})));
  ZoneSurface surLiv(surfaceName="Living:Interior")
    annotation (Placement(transformation(extent={{134,-44},{154,-24}})));
  HeatTransfer.Conduction.MultiLayer heaConGarWal(A=17.315,
                                                  layers=intWal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={140,0})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurGar
    annotation (Placement(transformation(extent={{104,20},{124,40}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaGarSur
    annotation (Placement(transformation(extent={{164,26},{184,46}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TSurLiv
    annotation (Placement(transformation(extent={{104,-44},{124,-24}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaLivSur
    annotation (Placement(transformation(extent={{168,-38},{188,-18}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard gypsum(
    x=0.0127,
    k=0.16,
    c=837,
    d(displayUnit="kg/m3") = 801) "Gypsum"
    annotation (Placement(transformation(extent={{140,66},{160,86}})));
  parameter HeatTransfer.Data.Solids.InsulationBoard           insul(
    x=0.09,
    k=0.043,
    c=837,
    d(displayUnit="kg/m3") = 10.0) "Insulation"
    annotation (Placement(transformation(extent={{114,66},{134,86}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic intWal(
    nLay=3,
    material={gypsum,insul,gypsum},
    absSol_a=0.75,
    absSol_b=0.75)
    annotation (Placement(transformation(extent={{172,66},{192,86}})));
equation
  connect(heaConGarWal.port_a, TSurGar.port) annotation (Line(points={{140,10},{
          90,10},{90,30},{104,30}}, color={191,0,0}));
  connect(TSurGar.T, surGar.T) annotation (Line(points={{124,30},{134,30},{134,26},
          {136,26},{136,30},{132,30}}, color={0,0,127}));
  connect(surGar.Q_flow, heaGarSur.Q_flow) annotation (Line(points={{156,36},{166,
          36},{166,32},{168,32},{168,36},{164,36}}, color={0,0,127}));
  connect(heaGarSur.port, heaConGarWal.port_a) annotation (Line(points={{184,36},
          {196,36},{196,10},{140,10}}, color={191,0,0}));
  connect(surLiv.Q_flow, heaLivSur.Q_flow)
    annotation (Line(points={{156,-28},{168,-28}}, color={0,0,127}));
  connect(heaLivSur.port, heaConGarWal.port_b) annotation (Line(points={{188,-28},
          {192,-28},{192,-10},{140,-10}}, color={191,0,0}));
  connect(TSurLiv.port, heaConGarWal.port_b) annotation (Line(points={{104,-34},
          {90,-34},{90,-10},{140,-10}}, color={191,0,0}));
  connect(TSurLiv.T, surLiv.T)
    annotation (Line(points={{124,-34},{132,-34}}, color={0,0,127}));
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
    Diagram(coordinateSystem(extent={{-100,-100},{200,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{200,140}})));
end InteriorSurfaceConduction;
