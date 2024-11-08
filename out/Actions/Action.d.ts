import { ActionOptions, RawActionEntry, ConsumerSignal } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Object that holds information about inputs that can be performed by the player while in a context.
 */
export declare class Action<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: A;
    private options;
    readonly Began: ConsumerSignal<(processed: boolean) => void>;
    readonly Ended: ConsumerSignal<(processed: boolean) => void>;
    readonly Cancelled: ConsumerSignal;
    constructor(RawAction: A, options?: ActionOptions);
    protected OnConnected(): void;
}
