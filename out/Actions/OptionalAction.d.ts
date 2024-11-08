import { ActionLike, ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that is used to act as a "ghost" action when placed inside objects that accepts multiple entries.
 * Its parent action can trigger without the need of the action being active, and will trigger again once the action activates.
 */
export declare class OptionalAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLike<A> | ActionLikeArray<A>;
    constructor(RawAction: ActionLike<A> | ActionLikeArray<A>);
    protected OnConnected(): void;
}
