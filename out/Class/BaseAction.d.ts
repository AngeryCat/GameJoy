/// <reference types="@rbxts/compiler-types" />
import { ActionLike, ActionLikeArray, ContextOptions, RawAction, RawActionEntry, ConsumerSignal } from "../Definitions/Types";
import { Context } from "./Context";
export declare abstract class BaseAction {
    protected readonly Connected: ConsumerSignal;
    protected readonly Changed: ConsumerSignal;
    readonly Content: ReadonlyArray<RawAction>;
    readonly RawAction: ActionLike<RawActionEntry> | ActionLikeArray<RawActionEntry>;
    readonly IsActive: boolean;
    readonly Resolved: ConsumerSignal;
    readonly Rejected: ConsumerSignal;
    readonly Triggered: ConsumerSignal<(processed?: boolean, ...params: Array<any>) => void>;
    readonly Released: ConsumerSignal<(processed?: boolean) => void>;
    readonly Destroyed: ConsumerSignal;
    readonly Context: Context<ContextOptions> | undefined;
    constructor();
    private VisitEachRawAction;
    protected LoadContent(): void;
    protected SetTriggered(value: boolean, ignoreEventCall?: boolean, ...args: Array<unknown>): void;
    protected abstract OnConnected(): void;
    /** @internal */
    SetContext<O extends ContextOptions>(context: Context<O> | undefined): void;
    /**
     * Checks if the action belongs to a context.
     */
    IsBound(): boolean;
    /**
     * Returns a list of the action's current active inputs.
     */
    GetActiveInputs(): RawAction[];
    /**
     * Returns a string list containing all the input names from the action.
     */
    GetContentString(): readonly ("Backspace" | "Tab" | "Clear" | "Return" | "Pause" | "Escape" | "Space" | "QuotedDouble" | "Hash" | "Dollar" | "Percent" | "Ampersand" | "Quote" | "LeftParenthesis" | "RightParenthesis" | "Asterisk" | "Plus" | "Comma" | "Minus" | "Period" | "Slash" | "Zero" | "One" | "Two" | "Three" | "Four" | "Five" | "Six" | "Seven" | "Eight" | "Nine" | "Colon" | "Semicolon" | "LessThan" | "Equals" | "GreaterThan" | "Question" | "At" | "LeftBracket" | "BackSlash" | "RightBracket" | "Caret" | "Underscore" | "Backquote" | "A" | "B" | "C" | "D" | "E" | "F" | "G" | "H" | "I" | "J" | "K" | "L" | "M" | "N" | "O" | "P" | "Q" | "R" | "S" | "T" | "U" | "V" | "W" | "X" | "Y" | "Z" | "LeftCurly" | "Pipe" | "RightCurly" | "Tilde" | "Delete" | "KeypadZero" | "KeypadOne" | "KeypadTwo" | "KeypadThree" | "KeypadFour" | "KeypadFive" | "KeypadSix" | "KeypadSeven" | "KeypadEight" | "KeypadNine" | "KeypadPeriod" | "KeypadDivide" | "KeypadMultiply" | "KeypadMinus" | "KeypadPlus" | "KeypadEnter" | "KeypadEquals" | "Up" | "Down" | "Right" | "Left" | "Insert" | "Home" | "End" | "PageUp" | "PageDown" | "LeftShift" | "RightShift" | "LeftMeta" | "RightMeta" | "LeftAlt" | "RightAlt" | "LeftControl" | "RightControl" | "CapsLock" | "NumLock" | "ScrollLock" | "LeftSuper" | "RightSuper" | "Mode" | "Compose" | "Help" | "Print" | "SysReq" | "Break" | "Menu" | "Power" | "Euro" | "Undo" | "F1" | "F2" | "F3" | "F4" | "F5" | "F6" | "F7" | "F8" | "F9" | "F10" | "F11" | "F12" | "F13" | "F14" | "F15" | "ButtonX" | "ButtonY" | "ButtonA" | "ButtonB" | "ButtonR1" | "ButtonL1" | "ButtonR2" | "ButtonL2" | "ButtonR3" | "ButtonL3" | "ButtonStart" | "ButtonSelect" | "DPadLeft" | "DPadRight" | "DPadUp" | "DPadDown" | "Thumbstick1" | "Thumbstick2" | "MouseButton1" | "MouseButton2" | "MouseButton3" | "MouseWheel" | "MouseMovement" | "Touch" | "Keyboard" | "Focus" | "Accelerometer" | "Gyro" | "Gamepad1" | "Gamepad2" | "Gamepad3" | "Gamepad4" | "Gamepad5" | "Gamepad6" | "Gamepad7" | "Gamepad8" | "TextInput" | "InputMethod" | "None")[];
    /**
     * Destroys the action and clean up its connections.
     */
    Destroy(): void;
}
