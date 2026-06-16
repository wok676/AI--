/**
 * 目标响应(API.md §4.16)。无目标时端点返回 null。
 */
export interface GoalDto {
  targetKcal: number;
  effectiveFrom: string;
  source: string;
}

/**
 * 估算响应(API.md §4.17)。建议参考值 + 固定免责声明(PRD §4.6 医疗红线)。
 */
export interface GoalEstimateDto {
  estimatedKcal: number;
  disclaimerKey: 'goal.disclaimer';
}
