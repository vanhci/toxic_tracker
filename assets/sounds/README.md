# 音效资源说明

这个目录存放惩罚音效文件。目前使用占位符，实际使用时需要添加真实的音频文件。

## 所需音效文件

以下音效文件是 `SoundService` 所需的：

1. `scream.mp3` - 尖叫声
2. `sad_trombone.mp3` - 沮丧的长号声
3. `buzzer.mp3` - 蜂鸣器声
4. `fail.mp3` - 失败音效
5. `boo.mp3` - 嘘声
6. `laugh.mp3` - 嘲笑声
7. `gong.mp3` - 锣声
8. `siren.mp3` - 警报声
9. `explosion.mp3` - 爆炸声
10. `cry.mp3` - 哭声

## 推荐音效来源

- [Freesound](https://freesound.org/) - 免费音效库
- [Pixabay](https://pixabay.com/sound-effects/) - 免费音效
- [Mixkit](https://mixkit.co/free-sound-effects/) - 免费音效

## 注意事项

1. 所有音效应该是免费可商用的
2. 音效时长建议控制在 1-3 秒
3. 文件大小尽量控制在 100KB 以内
4. 格式推荐使用 MP3

## 占位符行为

当音效文件不存在时，应用会：
1. 尝试加载音效文件
2. 如果失败，静默降级（不播放音效）
3. 使用震动作为替代反馈
