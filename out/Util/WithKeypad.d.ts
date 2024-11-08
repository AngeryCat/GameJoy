/// <reference types="@rbxts/types" />
import { Union } from "../Actions";
declare type NumberEnums = Enum.KeyCode.Zero | Enum.KeyCode.One | Enum.KeyCode.Two | Enum.KeyCode.Three | Enum.KeyCode.Four | Enum.KeyCode.Five | Enum.KeyCode.Six | Enum.KeyCode.Seven | Enum.KeyCode.Eight | Enum.KeyCode.Nine;
declare type SpecialCharEnums = Enum.KeyCode.Plus | Enum.KeyCode.Equals | Enum.KeyCode.Minus | Enum.KeyCode.Period;
declare type KeypadEntry = CastsToEnum<NumberEnums> | CastsToEnum<SpecialCharEnums> | StringNumbers;
declare type StringNumbers = "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9";
/**
 * Returns an union containing a number key and its numpad equivalent.
 */
export declare function WithKeypad<T extends KeypadEntry>(entry: T): Union<T>;
export {};
