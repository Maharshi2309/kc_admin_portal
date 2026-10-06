/// DEV ONLY: a stable number for a sample id (`'7'` → 7, `'s3'` → 3), used
/// to vary the dev mock's sample schedules and attendance per employee.
int mockSeedOf(String id) =>
    int.tryParse(id.replaceAll(RegExp(r'\D'), '')) ?? id.hashCode.abs();
