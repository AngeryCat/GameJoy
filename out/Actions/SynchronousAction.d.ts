import { ActionLike, ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that synchronizes its action when placed on the highest hierarchy.
 * Useful when the `RunSynchronously` option is disabled but you want a specific action to be executed synchronously.
 */
export declare class SynchronousAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLike<A> | ActionLikeArray<A>;
    constructor(RawAction: ActionLike<A> | ActionLikeArray<A>);
    protected OnConnected(): void;
}
