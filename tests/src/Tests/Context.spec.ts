/// <reference types="@rbxts/testez/globals" />

import { Context, Actions } from "@rbxts/gamejoy";

export = () => {
	const { Action } = Actions;
	const noop = () => {};

	describe("Methods", () => {
		const ctx = new Context();
		const action = new Action("Q");
		const action2 = new Action("E");

		it("Context.Options", () => {
			expect(ctx.Options).to.be.a("table");
		});

		it("Context.Bind", () => {
			ctx.Bind(action, noop).Bind(action2, noop);

			expect(ctx.Has(action)).to.equal(true);
			expect(ctx.Has(action2)).to.equal(true);
		});

		it("Context.Unbind", () => {
			ctx.Unbind(action).Unbind(action2);

			expect(ctx.Has(action)).to.equal(false);
			expect(ctx.Has(action2)).to.equal(false);
		});

		it("Context.UnbindAll", () => {
			ctx.Bind(action, noop).Bind(action2, noop);

			ctx.UnbindAll();

			expect(ctx.Has(action)).to.equal(false);
			expect(ctx.Has(action2)).to.equal(false);
		});
	});

	describe("Options", () => {
		const action = new Action("Q");
		const action2 = new Action("E");

		it("OnBefore", () => {
			const ctx = new Context({
				OnBefore: () => false,
			});

			const obj = { value: false };

			ctx.Bind(action, () => {
				obj.value = true;
			});

			action.Triggered.Fire();

			task.wait(0.3);

			expect(obj.value).to.equal(false);
		});

		it("RunSynchronously", () => {
			const ctx = new Context({
				RunSynchronously: true,
			});

			const obj = { a: false, b: false };

			ctx.Bind(action, () => {
				obj.a = true;
				task.wait(1);
			}).Bind(action2, () => {
				obj.b = true;
			});

			action.Triggered.Fire();
			action2.Triggered.Fire();

			task.wait(0.3);

			expect(obj.a && obj.b).to.equal(true);
		});

		it("Process", () => {
			const ctxArr = [
				new Context({
					Process: false,
				}),
				new Context({
					Process: true,
				}),
			] as const;
			const results = new Array<boolean>(2);

			for (const ctx of ctxArr) {
				const p = ctx.Options!.Process!;

				ctx.Bind(action, () => {
					results.push(p);
				});

				action.Triggered.Fire(p);
			}

			expect(
				results.size() === 2 && results[0] === false && results[1] === true,
			).to.equal(true);
		});
	});
};
