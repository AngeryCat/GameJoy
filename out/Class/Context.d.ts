/// <reference types="@rbxts/compiler-types" />
import { ActionEntry, ActionLike, ActionLikeArray, ActionListener, ContextOptions, RawActionEntry, SignalWrapper } from "../Definitions/Types";
import { Manual } from "../Actions";
interface Options extends Required<Omit<ContextOptions, "Process">> {
    Process?: boolean;
}
/**
 * Object responsible for storing and managing bound actions.
 *
 * `ActionGhosting`:
 * Limits the amount of actions that can trigger if those have any raw action in common. If set to 0, this property will be ignored.
 *
 * `OnBefore`:
 * Applies a check on every completed action. If the check fails, the action won't be triggered.
 *
 * `Process`:
 * Specifies that the action should trigger if gameProcessedEvent matches the setting. If nothing is passed, the action will trigger independently.
 *
 * `RunSynchronously`:
 * Specifies if the actions are going to run synchronously or not.
 * This will ignore the action queue and resolve the action instantly.
 */
export declare class Context<O extends ContextOptions> {
    private actions;
    private events;
    private pending;
    private isPending;
    private queue;
    readonly Options: Options;
    constructor(options?: O);
    private ConnectAction;
    private RemoveAction;
    /**
     * Checks if a certain action is bound to the context.
     */
    Has(action: ActionEntry): boolean;
    /**
     * Registers an action into the context.
     */
    Bind<R extends RawActionEntry, A extends ActionLike<R>>(action: A | ActionLikeArray<R>, listener: A extends Manual<infer P> ? ActionListener<P> : ActionListener): this;
    private _BindEvent;
    /**
     * Registers an event into the context.
     */
    BindEvent<P extends Array<unknown>>(name: string, event: SignalWrapper<(...args: P) => void>, listener: ActionListener<P>): this;
    /**
     * Registers a synchronous event into the context.
     */
    BindSyncEvent<P extends Array<unknown>>(name: string, event: SignalWrapper<(...args: P) => void>, listener: ActionListener<P>): this;
    /**
     * Removes an action from the context.
     */
    Unbind<R extends RawActionEntry, A extends ActionLike<R>>(action: A): this;
    /**
     * Removes an event connection from the context.
     */
    UnbindEvent(name: string): this;
    /**
     * Removes all bound actions from the context.
     */
    UnbindAllActions(): this;
    /**
     * Removes all bound events from the context.
     */
    UnbindAllEvents(): this;
    /**
     * Removes everything that is bound to the context.
     */
    UnbindAll(): this;
}
export {};
