import { ActionLikeArray, RawActionEntry, ConsumerSignal } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that requires all of its entries to be active in a specific order for it to trigger.
 */
export declare class SequenceAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLikeArray<A>;
    private queue;
    private canCancel;
    readonly Cancelled: ConsumerSignal;
    constructor(RawAction: ActionLikeArray<A>);
    protected OnConnected(): void;
}
