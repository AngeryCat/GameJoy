import type { Action, Axis, Union } from "../Actions";
interface ActionMap {
    Action: typeof Action;
    Axis: typeof Axis;
    Union: typeof Union;
}
declare type ActionKey = keyof ActionMap;
export declare function lazyLoad<K extends ActionKey>(name: K, callback: (action: ActionMap[K]) => void): void;
export declare function lazyRegister<K extends keyof ActionMap>(name: K, action: ActionMap[K]): void;
export {};
