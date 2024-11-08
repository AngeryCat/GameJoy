/// <reference types="signal" />
import Signal from "@rbxts/signal";
import { ActionLike, ActionLikeArray, AnyAction, AxisActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
/**
 * Variant that accepts any action as a parameter and can be updated.
 *
 * It has an `Update` method and a `.Updated` signal that fires whenever it's updated.
 */
export declare class DynamicAction<A extends AnyAction> extends BaseAction {
    readonly RawAction: AxisActionEntry | ActionLike<A> | ActionLikeArray<A>;
    private currentConnection;
    readonly Updated: Signal<() => void, false>;
    constructor(RawAction: AxisActionEntry | ActionLike<A> | ActionLikeArray<A>);
    private ConnectAction;
    protected OnConnected(): void;
    /**
     * Deactivates and updates the current action.
     */
    Update(newAction: AxisActionEntry | ActionLike<A> | ActionLikeArray<A>): void;
}
