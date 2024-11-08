/// <reference types="@rbxts/compiler-types" />
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that is used to act as a placeholder for manual triggering.
 */
export declare class ManualAction<P extends Array<unknown> = []> extends BaseAction {
    readonly RawAction: never[];
    constructor();
    protected OnConnected(): void;
    /**
     * Triggers the action object with the given parameters.
     */
    Trigger(...params: P): void;
}
