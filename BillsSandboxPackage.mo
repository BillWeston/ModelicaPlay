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
    // this is acomment reinit(v, -e*(if h<-eps then 0 else pre(v)));
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
    Modelica.Mechanics.Rotational.Components.Inertia inertia(J=0.01)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Modelica.Blocks.Sources.Sine sine(freqHz=0.1)
      annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));
  equation
    connect(inertia.flange_b, damper.flange_a) annotation (Line(
        points={{20,0},{40,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(damper.flange_b, fixed.flange) annotation (Line(
        points={{60,0},{80,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(torque.flange, inertia.flange_a) annotation (Line(
        points={{-20,0},{0,0}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(sine.y, torque.tau) annotation (Line(
        points={{-61,0},{-42,0}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
              100,100}}), graphics),
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
  annotation (uses(Modelica(version="3.2.1")));
end BillsSandboxPackage;
