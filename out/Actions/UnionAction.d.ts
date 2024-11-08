import { ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that accepts multiple entries as a parameter.
 */
export declare class UnionAction<A extends RawActionEntry> extends BaseAction {
    readonly RawAction: ActionLikeArray<A>;
    constructor(RawAction: ActionLikeArray<A>);
    protected OnConnected(): void;
}
