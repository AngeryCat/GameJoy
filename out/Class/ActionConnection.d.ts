/// <reference types="@rbxts/types" />
/// <reference types="@rbxts/compiler-types" />
import { ActionEntry } from "../Definitions/Types";
export declare class ActionConnection {
    Action: ActionEntry;
    private bin;
    private constructor();
    private Connect;
    static From(action: ActionEntry): ActionConnection;
    SendInputRequest(keyCode: Enum.KeyCode, inputType: Enum.UserInputType, processed: boolean, callback: (processed: boolean, ...args: Array<unknown>) => void): void;
    Began(callback: (processed: boolean) => void): void;
    Ended(callback: (processed: boolean) => void): void;
    Destroyed(callback: () => void): void;
    Triggered(callback: (processed?: boolean, ...args: Array<unknown>) => void): void;
    Released(callback: (processed?: boolean) => void): void;
    Changed(callback: () => void): void;
    Cancelled(callback: () => void): void;
    Destroy(): void;
}
