import { HashMap } from "@rbxts/rust-classes";

import { ActionConnection } from "../Util/ActionConnection";
import { ActionEntry, RawActionEntry } from "../Definitions/Types";
import { BaseAction } from "../Class/BaseAction";
import { Action } from "./Action";
import { UnionAction as Union } from "./UnionAction";

import { TransformAction } from "../Util/TransformAction";
import * as t from "../Util/TypeChecks";

function isOptional<A extends RawActionEntry>(action: ActionEntry<A>) {
	return t.ActionEntryIs(action, "OptionalAction");
}

export class CompositeAction<A extends RawActionEntry> extends BaseAction {
	private status: HashMap<ActionEntry<A>, boolean>;

	constructor(public readonly RawAction: Array<A | ActionEntry<A> | Array<A | ActionEntry<A>>>) {
		super();

		const status = (this.status = HashMap.empty());

		for (const entry of this.RawAction) {
			const action = TransformAction<A>(entry, Action, Union);
			status.insert(action, isOptional(action));
		}

		ActionConnection.From(this).Changed(() => {
			if (status.values().all((isPressed) => isPressed)) {
				return this.SetTriggered(true);
			}

			if (this.IsPressed) this.SetTriggered(false);
		});
	}

	protected OnConnected() {
		const { status } = this;

		status.keys().forEach((action) => {
			const connection = ActionConnection.From(action);
			action.SetContext(this.Context);

			connection.Triggered(() => {
				status.insert(action, true);

				this.Changed.Fire();
			});

			connection.Released(() => {
				if (!isOptional(action)) status.insert(action, false);

				this.Changed.Fire();
			});

			ActionConnection.From(this).Destroyed(() => {
				action.Destroy();
			});
		});
	}
}
