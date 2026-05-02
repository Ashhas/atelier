// Personal monthly goals — sample content for May 2026
// Categories user selected: Games, Actions/tasks, Learn, Achievements,
// Routines, Health/fitness, Books/media, plus free-form

const MONTH = {
  name: 'May',
  year: 2026,
  daysInMonth: 31,
  // "today" for the prototype — drives "days left" calculations
  today: 12,
  // 0 = Sunday … using Monday-start week
  firstWeekdayMonStart: 4, // May 1, 2026 falls on a Friday
};

const COMMITMENTS = {
  games: {
    label: 'Games',
    icon: 'gamepad',
    items: [
      { title: 'Hollow Knight: Silksong', meta: 'Finish main story' },
      { title: 'Balatro', meta: 'Reach Ante 8 with all decks' },
      { title: 'Elden Ring DLC', meta: 'Co-op with Mark, Sundays' },
    ],
  },
  actions: {
    label: 'Actions',
    icon: 'check',
    items: [
      { title: 'Renew passport', meta: 'Before May 20' },
      { title: 'Schedule dentist', meta: 'Overdue' },
      { title: 'Replace bike chain', meta: '' },
      { title: 'Tax filing', meta: 'Due May 31' },
    ],
  },
  learn: {
    label: 'Learn',
    icon: 'book',
    items: [
      { title: 'Rust ownership model', meta: '"Rust in Action" ch. 4–7' },
      { title: 'Tonal harmony basics', meta: '15 min/day at piano' },
      { title: 'Italian — A2 conversation', meta: 'Pimsleur unit 14–20' },
    ],
  },
  achieve: {
    label: 'Achieve',
    icon: 'trophy',
    items: [
      { title: 'Run a sub-25 5K', meta: 'PB now: 26:14' },
      { title: 'Ship side project v0.1', meta: 'Quiet launch by month-end' },
      { title: '€500 to brokerage', meta: 'Auto-transfer set' },
    ],
  },
  routines: {
    label: 'Routines',
    icon: 'loop',
    items: [
      { title: 'Read 20 min before bed', meta: 'Daily' },
      { title: 'No phone until 9am', meta: 'Weekdays' },
      { title: 'Cook dinner at home', meta: '5×/week' },
      { title: 'Journal — 3 lines', meta: 'Daily' },
    ],
  },
  health: {
    label: 'Health',
    icon: 'heart',
    items: [
      { title: 'Strength: 3× per week', meta: 'Push / pull / legs' },
      { title: 'Long run on Saturday', meta: 'Build to 12 km' },
      { title: 'Mobility 10 min', meta: 'Daily wake-up' },
    ],
  },
  media: {
    label: 'Reading & Watching',
    icon: 'book-open',
    items: [
      { title: 'The Beginning of Infinity', meta: 'Deutsch · finish' },
      { title: 'Severance S2', meta: 'Tue evenings' },
      { title: 'Working in Public', meta: 'Eghbal · start' },
    ],
  },
  free: {
    label: 'Other',
    icon: 'sparkle',
    items: [
      { title: 'Plan trip to Lisbon', meta: 'Book flights' },
      { title: 'Call grandma', meta: 'Twice this month' },
      { title: 'Reorganise studio desk', meta: '' },
    ],
  },
};

// Year goals — independent north-stars, no progress.
// Multiple per area allowed. 2026.
const YEAR_GOALS = [
  // Work
  { id: 'y1',  area: 'Work',  title: 'Ship 3 things I\u2019m proud of' },
  { id: 'y2',  area: 'Work',  title: 'Earn beyond salary \u2014 \u20ac10k side' },
  // Body
  { id: 'y3',  area: 'Body',  title: 'Run a sub-22 5K' },
  { id: 'y4',  area: 'Body',  title: 'Pull-up: bodyweight + 20kg' },
  { id: 'y5',  area: 'Body',  title: 'Sleep 7+ hrs, 6 nights/wk' },
  // Mind
  { id: 'y6',  area: 'Mind',  title: 'Read 24 books, write about 6' },
  // Skill
  { id: 'y7',  area: 'Skill', title: 'Hold a 30-min Italian conversation' },
  { id: 'y8',  area: 'Skill', title: 'Play a piece end-to-end at the piano' },
  // Daily — none, illustrating empty case
  // Play
  { id: 'y9',  area: 'Play',  title: 'Finish 6 games, beat at least one hard one' },
  // Life
  { id: 'y10', area: 'Life',  title: 'Spend a month abroad' },
  { id: 'y11', area: 'Life',  title: 'See parents 4+ times' },
];

// flat list (used by some variants)
const ALL_ITEMS = Object.entries(COMMITMENTS).flatMap(([key, cat]) =>
  cat.items.map((it) => ({ ...it, category: key, categoryLabel: cat.label }))
);

const CATEGORY_KEYS = Object.keys(COMMITMENTS);

// counts for the dashboard
const TOTAL_COUNT = ALL_ITEMS.length;

// quick "days left" helper
const daysLeft = MONTH.daysInMonth - MONTH.today;
const dayOfMonth = MONTH.today;
const monthProgress = MONTH.today / MONTH.daysInMonth;

Object.assign(window, {
  MONTH, COMMITMENTS, ALL_ITEMS, CATEGORY_KEYS, TOTAL_COUNT,
  daysLeft, dayOfMonth, monthProgress, YEAR_GOALS,
});
