import { ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that requires **only one** of its entries to be active for it to trigger.
 */
export declare class UniqueAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLikeArray<A>;
    private status;
    constructor(RawAction: ActionLikeArray<A>);
    protected OnConnected(): void;
}
