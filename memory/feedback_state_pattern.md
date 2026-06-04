---
name: State pattern for new features
description: Use SigninState<T> generic for all feature cubits - no new Freezed files needed
type: feedback
---

Reuse existing SigninState<T> from signin_state.dart for all feature cubits.

**Why:** Avoids creating new Freezed state files (which need build_runner to generate .freezed.dart). The generic SigninState<T> covers initial/loading/success/error and works with .when()/.maybeWhen() out of the box.
**How to apply:** class MyCubit extends BaseCubit<SigninState<List<MyModel>>>. Emit SigninState.loading(), SigninState.success(data), SigninState.error(msg).
