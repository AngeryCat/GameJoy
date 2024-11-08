import { ActionLike, ActionLikeArray, RawActionEntry } from "../Definitions/Types";
import type { OptionalAction } from "../Actions/OptionalAction";
export declare function isOptional<A extends RawActionEntry>(action: ActionLike<A> | ActionLikeArray<A>): action is OptionalAction<A>;
