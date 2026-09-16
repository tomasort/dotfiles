-- Daily/weekly/monthly journaling in plain markdown under ~/journal.
-- Entries render via render-markdown.nvim; historical entries are
-- searchable with fzf <leader>fg like every other file.
return {
	{
		"jakobkhansen/journal.nvim",
		keys = {
			{ "<leader>jj", function() require("journal").command("day") end, desc = "Journal: today" },
			{ "<leader>jw", function() require("journal").command("week") end, desc = "Journal: this week" },
			{ "<leader>jm", function() require("journal").command("month") end, desc = "Journal: this month" },
			{ "<leader>jy", function() require("journal").command("year") end, desc = "Journal: this year" },
			{ "<leader>jp", function() require("journal").command("day -1") end, desc = "Journal: yesterday" },
			{ "<leader>jn", function() require("journal").command("day +1") end, desc = "Journal: tomorrow" },
		},
		cmd = { "Journal" },
		opts = {
			filetype = "md",
			root = "~/journal",
			journal = {
				-- default entry = day (used by :Journal <date-modifier>).
				-- NOTE: plugin merges user opts by shallow-overwrite, so the
				-- journal table must be complete incl. top-level frequency
				frequency = { day = 1 },
				format = "%Y/%m-%B/daily/%d-%A",
				template = "# %A, %B %d %Y\n\n## What happened\n\n## Learnings\n\n",
				entries = {
					day = {
						-- 2026/09-September/daily/15-Tuesday.md
						format = "%Y/%m-%B/daily/%d-%A",
						template = "# %A, %B %d %Y\n\n## What happened\n\n## Learnings\n\n",
						frequency = { day = 1 },
					},
					week = {
						format = "%Y/%m-%B/weekly/week-%W",
						template = "# Week %W, %B %Y\n",
						frequency = { day = 7 },
						date_modifier = "monday",
					},
					month = {
						format = "%Y/%m-%B/%B",
						template = "# %B %Y\n",
						frequency = { month = 1 },
					},
					year = {
						format = "%Y/%Y",
						template = "# %Y\n",
						frequency = { year = 1 },
					},
				},
			},
		},
	},
}
