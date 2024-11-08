/// <reference types="@rbxts/types" />
import { AxisActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that provides support for inputs that have a continuous range.
 * The action is triggered everytime the input is changed.
 */
export declare class AxisAction<A extends AxisActionEntry> extends BaseAction {
    readonly RawAction: A;
    readonly Delta: Vector3;
    readonly Position: Vector3;
    readonly KeyCode: Enum.KeyCode;
    constructor(RawAction: A);
    protected OnConnected(): void;
}
