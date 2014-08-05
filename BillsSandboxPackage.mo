within ;
package BillsSandboxPackage "A place for Bill to experiment"
  model BillsBoundingBallModel
    "This is slow because it has an if in the tight loopInvestigate using when instead"

  type Height=Real(unit="m");
  type Velocity=Real(unit="m/s");
  parameter Real e=0.8 "Coefficient of restitution";
  parameter Height h0=1.0 "Initial height";

  Height h;
  Velocity v;
  initial equation
  h = h0;

  equation
  v = der(h);
  der(v) =  if (h<0) then 0 else -9.81;
  when h<0 then
    // this is a comment reinit(v, -e*(if h<-eps then 0 else pre(v)));
    reinit(v,e*abs(pre(v)));
    reinit(h,0);
  end when;

  end BillsBoundingBallModel;

  model ColourChange "Model to see if can change colour on value"

    Modelica.Mechanics.Rotational.Components.Damper damper(d=1) annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={50,0})));
    Modelica.Mechanics.Rotational.Components.Fixed fixed annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={80,0})));
    Modelica.Mechanics.Rotational.Sources.Torque torque
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Modelica.Blocks.Sources.Constant TestInput(k=100)
      annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
    Chameleonertia loaded
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Chameleonertia unloaded
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));

  equation
    connect(damper.flange_b, fixed.flange) annotation (Line(
        points={{60,0},{80,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(TestInput.y, torque.tau) annotation (Line(
        points={{-61,0},{-42,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(torque.flange, loaded.flange_a) annotation (Line(
        points={{-20,0},{-10,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(loaded.flange_b, damper.flange_a) annotation (Line(
        points={{10,0},{40,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(damper.flange_a, unloaded.flange_b) annotation (Line(
        points={{40,0},{26,0},{26,-30},{10,-30}},
        color={0,0,0},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
              100}}),     graphics),
      experiment(StopTime=60),
      __Dymola_experimentSetupOutput);

  end ColourChange;

  model InterpolationPlay "See if I can use tables for interpolation"

    Modelica.Blocks.Sources.Sine sine(freqHz=0.1)
      annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
    Modelica.Blocks.Tables.CombiTable1Ds EnergyEfficiency(table=[0.0,0.0; 0.1,0.25;
          0.2,0.45; 0.3,0.55; 0.4,0.70; 0.5,0.8; 0.6,0.85; 0.7,0.89; 0.8,0.9; 0.9,
          0.91; 1.0,1.0])
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-10,0})));
    Modelica.Blocks.Tables.CombiTable1Ds TorqueRatio(table=[0.0, 2.2; 0.1, 2.01; 0.2, 1.87; 0.3, 1.80; 0.4, 1.65; 0.5, 1.6; 0.6, 1.50; 0.7, 1.30; 0.8, 1.2; 0.9, 1.00; 1.0, 1.0])
      "Ratio of output to input torque for a given speed ratioo."
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-10,-30})));
  equation
    connect(sine.y, EnergyEfficiency.u) annotation (Line(
        points={{-61,0},{-22,0}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sine.y, TorqueRatio.u) annotation (Line(
        points={{-61,0},{-42,0},{-42,-30},{-22,-30}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics),
      experiment(StopTime=60),
      __Dymola_experimentSetupOutput);
  end InterpolationPlay;

  model Chameleonertia "An inertia that changes colour"

    Modelica.Mechanics.Rotational.Interfaces.Flange_a flange_a
      "Left flange of shaft"
      annotation (Placement(transformation(extent={{-110,-10},{-90,10}},
            rotation=0)));
    Modelica.Mechanics.Rotational.Interfaces.Flange_b flange_b
      "Right flange of shaft"
      annotation (Placement(transformation(extent={{90,-10},{110,10}},
            rotation=0)));
   // extends Modelica.Mechanics.Rotational.Components.Inertia
    Modelica.Mechanics.Rotational.Components.Inertia inertia(
      phi(start=0),
      w(start=0),
      a(start=0),
      J=1)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    Real driven(start = 0);
  equation
    driven = flange_a.tau;
    connect(flange_a, inertia.flange_a) annotation (Line(
        points={{-100,0},{-10,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(inertia.flange_b, flange_b) annotation (Line(
        points={{10,0},{100,0}},
        color={0,0,0},
        smooth=Smooth.None));
     annotation (     Icon(
    coordinateSystem(preserveAspectRatio=true,
      extent={{-100.0,-100.0},{100.0,100.0}},
      initialScale=0.1),
    graphics={
      Rectangle(lineColor={64,64,64},
        fillColor={192,192,192},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-100.0,-10.0},{-50.0,10.0}}),
      Rectangle(lineColor={64,64,64},
        fillColor={192,192,192},
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{50.0,-10.0},{100.0,10.0}}),
      Line(points={{-80.0,-25.0},{-60.0,-25.0}}),
      Line(points={{60.0,-25.0},{80.0,-25.0}}),
      Line(points={{-70.0,-25.0},{-70.0,-70.0}}),
      Line(points={{70.0,-25.0},{70.0,-70.0}}),
      Line(points={{-80.0,25.0},{-60.0,25.0}}),
      Line(points={{60.0,25.0},{80.0,25.0}}),
      Line(points={{-70.0,45.0},{-70.0,25.0}}),
      Line(points={{70.0,45.0},{70.0,25.0}}),
      Line(points={{-70.0,-70.0},{70.0,-70.0}}),
      Rectangle(lineColor={64,0,0},
        fillColor=DynamicSelect({255,255,255}, if driven > 5 then {255,0,0} else
                      {255,255,255}),
        fillPattern=FillPattern.HorizontalCylinder,
        extent={{-50.0,-50.0},{50.0,50.0}},
        radius=10.0),
      Text(lineColor={0,0,255},
        extent={{-150.0,60.0},{150.0,100.0}},
        textString="hello"),
      Text(extent={{-150.0,-120.0},{150.0,-80.0}},
        textString="K=%J"),
      Rectangle(
        lineColor = {64,64,64},
        fillColor = {255,0,0},
        extent = {{-50,-50},{50,50}},
        radius = 10)}), Diagram(coordinateSystem(preserveAspectRatio=false,
            extent={{-100,-100},{100,100}}), graphics));
  end Chameleonertia;
  annotation (uses(Modelica(version="3.2.1"),
      VehicleInterfaces(version="1.2.1"),
      OpenHydraulics(version="1.0")));
  model Dyno "DynoPlay"

    CyTransmission.Components.KinematicZF9HP kinematicZF9HP(usingMultiBodyEngine=false,
        usingMultiBodyDriveline=false)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    inner replaceable OpenHydraulics.Fluids.GenericOilSimple oil "Oil model"
                  annotation(choicesAllMatching=true,Placement(transformation(extent={{-70,80},
              {-50,100}})));
  public
    Modelica.Blocks.Sources.IntegerTable integerTable1(
                                                      table=[0,0; 1,1; 2,2; 3,
          3; 4,4; 5,5; 6,6; 7,7; 8,8; 9,9; 10,8; 11,7; 12,6; 13,5; 14,4; 15,3;
          16,2; 17,1; 18,0; 19,-1])
      "This is the pattern of gears for this test case."
      annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  protected
    VehicleInterfaces.Interfaces.ControlBus controlBus2 "Control signal bus"
      annotation (Placement(transformation(extent={{-32,50},{-12,70}})));
    replaceable VehicleInterfaces.Transmissions.Interfaces.StandardControlBus
                                                        transmissionControlBus1
      constrainedby VehicleInterfaces.Interfaces.TransmissionControlBus
      annotation (Placement(transformation(extent={{-60,50},{-40,70}},
            rotation=0)));
  public
    Modelica.Mechanics.Rotational.Sources.Torque
                              torque(useSupport=false)
                                                      annotation (Placement(
          transformation(extent={{-70,-10},{-50,10}},  rotation=0)));
    Modelica.Blocks.Sources.Sine sin1(
      amplitude=20,
      freqHz=10,
      offset=20)                                              annotation (
        Placement(transformation(extent={{-100,-10},{-80,10}},  rotation=0)));
    Modelica.Mechanics.Rotational.Components.Inertia
                                  J2(
      phi(fixed=false, start=0),
      J=1,
      w(start=7, fixed=false)) annotation (Placement(transformation(extent={{22,-10},
              {42,10}},           rotation=0)));
    Modelica.Mechanics.Rotational.Components.Damper damper(d=0.001)
      annotation (Placement(transformation(extent={{52,-10},{72,10}})));
    Modelica.Mechanics.Rotational.Components.Fixed fixed
      annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  equation
    connect(transmissionControlBus1, controlBus2.transmissionControlBus)
      annotation (Line(
        points={{-50,60},{-22,60}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%second",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(integerTable1.y, transmissionControlBus1.currentGear) annotation (
        Line(
        points={{-79,60},{-50,60}},
        color={255,127,0},
        smooth=Smooth.None), Text(
        string="%second",
        index=1,
        extent={{6,3},{6,3}}));
    connect(controlBus2, kinematicZF9HP.controlBus) annotation (Line(
        points={{-22,60},{-16,60},{-16,6}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None), Text(
        string="%first",
        index=-1,
        extent={{-6,3},{-6,3}}));
    connect(sin1.y,torque.tau)
      annotation (Line(points={{-79,0},{-72,0}},   color={0,0,127}));
    connect(torque.flange, kinematicZF9HP.engineFlange.flange);
    connect(damper.flange_b,fixed. flange) annotation (Line(
        points={{72,0},{90,0}},
        color={0,0,0},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end Dyno;
end BillsSandboxPackage;
