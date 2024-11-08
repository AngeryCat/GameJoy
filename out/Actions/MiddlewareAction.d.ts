import { ActionLike, ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that accepts a callback that can be used to set a condition to your action.
 */
export declare class MiddlewareAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLike<A> | ActionLikeArray<A>;
    constructor(RawAction: ActionLike<A> | ActionLikeArray<A>, middleware: (action: MiddlewareAction<A>) => boolean);
    private Middleware;
    protected OnConnected(): void;
}
