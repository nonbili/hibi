/**
 * A module to make Hibi run with or without tauri.
 *
 * When running in tauri, use tauri APIs to read/write files.
 * Otherwise, use localStorage.
 */

import * as TauriFS from "tauri/api/fs";

const userAgent = navigator.userAgent.toLowerCase();

// A hacky way to detect if running on tauri.
export const tauriOn = !(
  userAgent.includes("firefox") || userAgent.includes("chrome")
);

export const readFile = file =>
  tauriOn
    ? TauriFS.readTextFile(file)
    : (() => {
        const data = localStorage.getItem(file);
        return data ? Promise.resolve(data) : Promise.reject("");
      })();

export const writeFile = (file, contents) =>
  tauriOn
    ? TauriFS.writeFile({ file, contents })
    : Promise.resolve(localStorage.setItem(file, contents));

export const removeFile = file =>
  tauriOn
    ? TauriFS.removeFile(file)
    : Promise.resolve(localStorage.removeItem(file));

if (tauriOn) {
  // Init hibi filder inside the system config folder. e.g. `~/.config/hibi` on
  // Linux.
  const configDirOption = { dir: TauriFS.Dir.Config };
  TauriFS.readDir("hibi", configDirOption).then(
    () => {},
    () => {
      TauriFS.createDir("hibi", configDirOption);
    }
  );
}

const appDirOption = { dir: TauriFS.Dir.App };

export const readConfig = () =>
  tauriOn
    ? TauriFS.readTextFile("config.json", appDirOption).then(JSON.parse)
    : Promise.resolve({ dataDir: "hibi" });

export const writeConfig = config => {
  const contents = JSON.stringify(config);
  tauriOn
    ? TauriFS.writeFile({ file: "config.json", contents }, appDirOption)
    : Promise.resolve(localStorage.setItem("hibi", contents));
};
