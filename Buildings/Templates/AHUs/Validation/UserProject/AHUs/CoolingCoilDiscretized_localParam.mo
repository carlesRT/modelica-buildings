within Buildings.Templates.AHUs.Validation.UserProject.AHUs;
model CoolingCoilDiscretized_localParam
  extends VAVSingleDuct(
    final id="VAV_1",
    redeclare Coils.WaterBased coiCoo(
      redeclare
        Buildings.Templates.AHUs.Coils.HeatExchangers.Discretized
        coi),
      redeclare replaceable record RecordCoiCoo = Coils.Data.WaterBased (
        redeclare
          Buildings.Templates.AHUs.Coils.HeatExchangers.Data.Discretized
          datHex(UA_nominal=testUA)));

  annotation (
    defaultComponentName="ahu");
end CoolingCoilDiscretized_localParam;