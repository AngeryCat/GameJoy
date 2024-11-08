/// <reference types="@rbxts/compiler-types" />
import { Vec } from "@rbxts/rust-classes";
import { Bin } from "@rbxts/bin";
import { ActionEntry, ActionListener } from "../Definitions/Types";
interface QueueEntry {
    action: ActionEntry;
    bin: Bin;
    executable: () => Promise<Promise<void>>;
    isExecuting: boolean;
}
export declare class ActionQueue {
    private readonly updated;
    readonly Entries: Vec<QueueEntry>;
    constructor();
    private Reject;
    Add(action: ActionEntry, listener: ActionListener): void;
    private Remove;
}
export {};
