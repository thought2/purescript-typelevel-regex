import * as fs from "fs";
import * as cp from "child_process";
import dedent from "dedent";

const testFile = "test/Test/Tmp.purs";

const run = (src) => {
  fs.writeFileSync(testFile, dedent(src));
  const result = cp.spawnSync("spago", ["build", "--json-errors"]);

  return result;
};

export const shouldNotCompile = (src, expectedError) => {
  const result = run(src);

  if (result.status === 0) {
    console.log("Expected compilation to fail, but it succeeded.")
    process.exit(1);
  }

  const resultStr = result.stdout.toString();
  const resultJson = JSON.parse(resultStr);

  const errorMsg = resultJson.errors[0].message;

  if (!errorMsg.includes(expectedError)) {
    console.log(`Expected error message to include: ${expectedError}.`);
    console.log({src, errorMsg});
    process.exit(1);
  }

  fs.rmSync(testFile);
};

export const shouldCompile = (src) => {
  const result = run(src);

  if (result.status !== 0) {
    const resultStr = result.stdout.toString();
    const resultJson = JSON.parse(resultStr);
    
    console.log(JSON.stringify(resultJson, null, 2));

    process.exit(1);
  }

  fs.rmSync(testFile);
};
