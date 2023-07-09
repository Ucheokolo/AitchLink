import React from "react";
import { useState } from "react";

const ToggleDiv = () => {
  const [showDiv, setShowDiv] = useState(false);

  const toggleDiv = () => {
    setShowDiv(!showDiv);
  };
  return (
    <div>
      <button onClick={toggleDiv}>Register Launchpad</button>
      {showDiv && <div>This is the div to be shown/hidden.</div>}
    </div>
  );
};

export default ToggleDiv;
