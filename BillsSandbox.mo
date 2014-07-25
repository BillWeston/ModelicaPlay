within ;
package BillsSandbox "A place for Bill to experiment"
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

  annotation (uses(Modelica(version="3.2.1")));
end BillsSandbox;
