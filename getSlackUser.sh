#!/usr/bin/env bash
# Usage
# author=$(./getSlackUser.sh)
# or
# author=$(curl –silent -L 'https://raw.githubusercontent.com/debitoor/teamcity-merge/master/getSlackUser.sh' | bash)


#Map of emails -> slack user name
getSlackName(){
	echo `node -e "console.log({
	'eagleeyes91@gmail.com': 'eagleeye',
	'bogdan.bele@yahoo.com': 'bogdanbele',
	'anton.mamant@gmail.com': 'mamant',
	'mpush@inbox.ru': 'mpushkin',
	'jp@jonatanpedersen.com': 'jonatanpedersen',
	'kollner@gmail.com': 'kollner',
	'hiller@live.dk': 'hilleer',
	'ayverend@gmail.com': 'dasha',
	'alexeymalyarov@gmail.com': 'lex',
	'mfbeast@mail.ru': 'mpushkin',
	'niklasgundlev@gmail.com': 'niklas',
	'marcentusch@hotmail.com': 'moe',
	'dgulkovskiy@gmail.com': 'dima'
	}['$1']||'')"`
}

function getSlackUser()
{
	email=`git log --pretty=format:'%ae' -n 1`
	if [ "${email}" = 'debitoor-bot@debitoor.com' ]
	then
		echo "TeamCity"
	else
		slackUser=`getSlackName "${email}"`
		users=`curl -X POST "https://slack.com/api/users.list?token=${SLACK_TOKEN}" -s`
		slackUserId=`node -e "let users =  ${users}; console.log(users.members.reduce((acc,m)=>{ if(m.name==='${slackUser}'||m.profile.email==='${email}'){return m.id} return acc;}, ''))"`
		slackUser=`node -e "let users =  ${users}; console.log(users.members.reduce((acc,m)=>{ if(m.name==='${slackUser}'||m.profile.email==='${email}'){return m.name} return acc;}, ''))"`
		if [ "${slackUserId}" = '' ]
		then
			echo "${slackUser}|${email} (could not find this slack-username or email in slack?! Fix it here: https://github.com/debitoor/teamcity-merge/blob/master/getSlackUser.sh)"
		else
			echo "<@${slackUserId}|${slackUser}>"
		fi
	fi
}


echo $(getSlackUser)
