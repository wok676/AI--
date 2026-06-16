/**
 * 本地日期工具:统一产出 `YYYY-MM-DD`(MealEntry.localDate / RecognitionUsage.localDate /
 * DailyGoal.effectiveFrom 的聚合键,DB-Schema §6/§7/§8)。
 * 避免时区漂移导致跨日错算。校验严格:非法格式直接拒绝,防脏聚合键。
 */
const LOCAL_DATE_RE = /^\d{4}-\d{2}-\d{2}$/;

/** 校验 `YYYY-MM-DD` 且为真实日历日(拒绝 2026-13-40 之类)。 */
export function isValidLocalDate(value: string): boolean {
  if (!LOCAL_DATE_RE.test(value)) return false;
  const [y, m, d] = value.split('-').map((s) => parseInt(s, 10));
  if (m < 1 || m > 12 || d < 1 || d > 31) return false;
  const dt = new Date(Date.UTC(y, m - 1, d));
  return dt.getUTCFullYear() === y && dt.getUTCMonth() === m - 1 && dt.getUTCDate() === d;
}

/** 取某 UTC 时刻的 `YYYY-MM-DD`(服务端兜底用;客户端传入 localDate 时优先用客户端值)。 */
export function toLocalDateUTC(date: Date = new Date()): string {
  return date.toISOString().slice(0, 10);
}

/** 从 `YYYY-MM-DD` 回退 N 天,产出降序日期数组(含起始日),供趋势端点用。 */
export function recentLocalDates(endDate: string, days: number): string[] {
  const [y, m, d] = endDate.split('-').map((s) => parseInt(s, 10));
  const base = Date.UTC(y, m - 1, d);
  const out: string[] = [];
  for (let i = 0; i < days; i++) {
    out.push(new Date(base - i * 86400000).toISOString().slice(0, 10));
  }
  return out;
}
