require('pry')
require_relative('models/bounty')

Bounty.delete_all()

bounty1 = Bounty.new({'name' => 'Thing',
                      'species' => 'Unkown',
                      'bounty_value' => 4,
                      'danger_level' => 6
                      })
bounty1.save()

bounty2 = Bounty.new({'name' => 'Thing2',
                      'species' => 'Unkown',
                      'bounty_value' => 5,
                      'danger_level' => 6
                      })

bounty2.save()

bounty1.bounty_value = 8
bounty1.update()
Bounty.find_by_name('Thing')
Bounty.find_by_id(2)
