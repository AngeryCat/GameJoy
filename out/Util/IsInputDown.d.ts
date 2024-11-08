/// <reference types="@rbxts/compiler-types" />
import { RawActionEntry } from "../Definitions/Types";
/**
 * Checks if all the specified inputs are being pressed.
 */
export declare function IsInputDown(input: RawActionEntry | Array<RawActionEntry>): boolean;
/**
 * Checks if any of the specified inputs is being pressed.
 */
export declare function IsAnyInputDown(inputs: Array<RawActionEntry>): boolean;
