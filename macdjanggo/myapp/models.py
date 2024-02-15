# models.py

from django.db import models

class leaderboard(models.Model):
    username = models.CharField(max_length=150)
    score = models.IntegerField(default=0)  # 积分
    achievements = models.IntegerField(default=0)  # 成就数量
    login_days = models.IntegerField(default=0)  # 登录天数
    carbon_footprint = models.FloatField(default=0.0)  # 碳足迹

    def __str__(self):
        return self.username
