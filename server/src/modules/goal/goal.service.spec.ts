import { GoalService } from './goal.service';
import { ActivityLevel, GoalType, Sex } from '../../common/domain/enums';

/**
 * 单元测试:Mifflin-St Jeor 估算(纯计算,不触 DB)。
 * 校验公式正确 + 固定免责声明(PRD §4.6 医疗红线)。
 */
describe('GoalService.estimate (Mifflin-St Jeor)', () => {
  // prisma 不参与 estimate,传 null 即可
  const service = new GoalService(null as never);

  it('male, moderate, maintain → expected TDEE band + disclaimer', () => {
    const res = service.estimate({
      sex: Sex.MALE,
      birthYear: new Date().getFullYear() - 30, // age 30
      heightCm: 175,
      weightKg: 70,
      activityLevel: ActivityLevel.MODERATE,
      goalType: GoalType.MAINTAIN,
    });
    // BMR = 10*70 + 6.25*175 - 5*30 + 5 = 700 + 1093.75 - 150 + 5 = 1648.75
    // TDEE = 1648.75 * 1.55 = 2555.5625 → round to nearest 10 = 2560
    expect(res.estimatedKcal).toBe(2560);
    expect(res.disclaimerKey).toBe('goal.disclaimer');
  });

  it('female lose < maintain < gain (goal factor ordering)', () => {
    const base = {
      sex: Sex.FEMALE,
      birthYear: new Date().getFullYear() - 28,
      heightCm: 165,
      weightKg: 60,
      activityLevel: ActivityLevel.LIGHT,
    };
    const lose = service.estimate({ ...base, goalType: GoalType.LOSE }).estimatedKcal;
    const maintain = service.estimate({ ...base, goalType: GoalType.MAINTAIN }).estimatedKcal;
    const gain = service.estimate({ ...base, goalType: GoalType.GAIN }).estimatedKcal;
    expect(lose).toBeLessThan(maintain);
    expect(maintain).toBeLessThan(gain);
  });

  it('unspecified sex uses averaged adjustment (between male and female)', () => {
    const base = {
      birthYear: new Date().getFullYear() - 40,
      heightCm: 170,
      weightKg: 75,
      activityLevel: ActivityLevel.SEDENTARY,
      goalType: GoalType.MAINTAIN,
    };
    const male = service.estimate({ ...base, sex: Sex.MALE }).estimatedKcal;
    const female = service.estimate({ ...base, sex: Sex.FEMALE }).estimatedKcal;
    const unspec = service.estimate({ ...base, sex: Sex.UNSPECIFIED }).estimatedKcal;
    expect(unspec).toBeLessThan(male);
    expect(unspec).toBeGreaterThan(female);
  });
});
