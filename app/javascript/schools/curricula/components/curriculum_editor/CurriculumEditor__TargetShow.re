open CurriculumEditor__Types;

let str = ReasonReact.string;

type props = {target: Target.t};

let component =
  ReasonReact.statelessComponent("CurriculumEditor__TargetShow");

let make = (~target, _children) => {
  ...component,
  render: _self =>
    <div className="target-group__target bg-white border p-5">
      <h5 className="font-semibold"> {target |> Target.title |> str} </h5>
    </div>,
};