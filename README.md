# docker-dev-for-php-laraval-mysql

完整解决方案
1. 首先确认项目结构
确保你的项目目录结构应该是这样的
voice-platform/
├── docker/
│   ├── docker-compose.yml
│   └── Dockerfile
└── src/
    ├── artisan      <-- 这个文件必须存在
    ├── app/
    ├── bootstrap/
    └── vendor/



重新创建 Laravel 项目（正确方式）
# 确保在项目根目录
cd ~/Projects/voice-platform

# 清空src目录
rm -rf src/*

# 使用正确的挂载方式创建项目
docker run --rm -v $(pwd)/src:/var/www composer \
    composer create-project laravel/laravel /var/www --prefer-dist


MySQL错误日志
docker-compose -f docker/docker-compose.yml logs mysql

删除旧数据卷：
docker-compose -f docker/docker-compose.yml down -v

重建数据库结构
docker-compose -f docker/docker-compose.yml exec app php artisan migrate:fresh


完整重建：
docker-compose -f docker/docker-compose.yml up -d --build
docker-compose -f docker/docker-compose.yml exec app php artisan migrate

验证网络连接-从app容器测试连接MySQL
docker-compose -f docker/docker-compose.yml exec app bash -c "nc -zv mysql 3306"


验证MySQL版本兼容性
docker-compose -f docker/docker-compose.yml exec mysql mysql --version

检查 MySQL 容器状态
docker-compose -f docker/docker-compose.yml ps

常见问题排查
检查防火墙规则：
sudo ufw status  # 如果是active状态，暂时禁用
sudo ufw disable

检查 MySQL 用户权限
使用root用户进入MySQL
docker-compose -f docker/docker-compose.yml exec mysql mysql -uroot -psecret
在MySQL命令行执行
GRANT ALL PRIVILEGES ON voice_platform.* TO 'laravel'@'%';
FLUSH PRIVILEGES;
EXIT;

检查挂载卷是否生效：
docker inspect voice-platform-app-1 | grep Mounts -A 10
确认 src 目录正确挂载到容器的 /var/www/html

手动测试 artisan：
docker-compose -f docker/docker-compose.yml exec app php /var/www/html/artisan --version

替代快速解决方案
如果时间紧迫，可以直接在容器内安装 Laravel：
docker-compose -f docker/docker-compose.yml exec app bash -c \
    "cd /var/www/html && composer create-project laravel/laravel . --prefer-dist"

