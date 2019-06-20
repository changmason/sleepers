now = Time.now
last_week = now - 8.days

mason = User.create(name: 'Mason', email: 'mason@example.com')
nicole = User.create(name: 'Nicole', email: 'nicole@example.com')
puts "Tow test users created:"
puts mason.attributes.inspect
puts nicole.attributes.inspect

nicole.sleeps.create(uuid: SecureRandom.uuid, slept_at: now - 10.hour, waked_at: now, created_at: now)
nicole.sleeps.create(uuid: SecureRandom.uuid, slept_at: last_week - 12.hour, waked_at: last_week, created_at: last_week)

mason.followings << nicole