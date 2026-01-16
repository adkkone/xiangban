import '../models/workout.dart';

class WorkoutData {
  static List<Workout> getFeaturedWorkouts() {
    return [
      Workout(
        id: '1',
        title: '日落慢跑',
        description: '提升耐力，享受定制的轻松慢跑。',
        duration: 45,
        intensity: '有氧',
        imageUrl: 'assets/images/run.png',
        category: 'cardio',
      ),
      Workout(
        id: '2',
        title: '燃脂燃烧',
        description: '高效燃脂训练。',
        duration: 20,
        intensity: '高强度',
        imageUrl: 'https://images.unsplash.com/photo-1601422407692-ec4eeec1d9b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'hiit',
      ),
    ];
  }

  static List<Workout> getQuickActions() {
    return [
      Workout(
        id: '3',
        title: '晨间拉伸',
        description: '唤醒身体',
        duration: 10,
        intensity: '轻松',
        imageUrl: 'assets/images/fitness/woman doing yoga on stability ball.jpg',
        category: 'stretch',
      ),
      Workout(
        id: '4',
        title: '冥想',
        description: '心灵冥想',
        duration: 15,
        intensity: '轻松',
        imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'meditation',
      ),
    ];
  }

  static List<Workout> getAllWorkouts() {
    return [
      Workout(
        id: '5',
        title: '全身燃脂',
        description: '高强度间歇训练，快速燃烧全身脂肪',
        duration: 30,
        intensity: '高强度',
        imageUrl: 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'hiit',
      ),
      Workout(
        id: '6',
        title: '核心力量',
        description: '强化核心肌群，改善体态',
        duration: 25,
        intensity: '中等',
        imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'strength',
      ),
      Workout(
        id: '7',
        title: '上肢塑形',
        description: '打造紧致有型的上肢线条',
        duration: 35,
        intensity: '中等',
        imageUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'strength',
      ),
      Workout(
        id: '8',
        title: '瑜伽流动',
        description: '温和的瑜伽序列，放松身心',
        duration: 40,
        intensity: '轻松',
        imageUrl: 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'yoga',
      ),
      Workout(
        id: '9',
        title: '有氧舞蹈',
        description: '动感音乐配合有氧运动',
        duration: 45,
        intensity: '中等',
        imageUrl: 'https://images.unsplash.com/photo-1518611012118-696072aa579a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'cardio',
      ),
      Workout(
        id: '10',
        title: '腿部训练',
        description: '强化下肢力量，塑造腿部线条',
        duration: 30,
        intensity: '高强度',
        imageUrl: 'https://images.unsplash.com/photo-1434682881908-b43d0467b798?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        category: 'strength',
      ),
    ];
  }
}
