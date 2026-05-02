// Atelier v3 — goals as a wall, not a list.
// Top bar is preserved exactly. Below: a typographic mosaic where
// goals are grouped by area but not ranked. Each goal sized by
// commitment weight. Areas labelled in the gutter, not as headers.

const PALETTES = {
  light: {
    bg:      '#ffffff',
    panel:   '#fafafa',
    ink:     '#0a0a0a',
    sub:     '#525252',
    mute:    '#a3a3a3',
    rule:    '#ededed',
    accent:  '#0a0a0a',
    chip:    '#f5f5f5',
  },
  dark: {
    bg:      '#0a0a0a',
    panel:   '#141414',
    ink:     '#fafafa',
    sub:     '#a3a3a3',
    mute:    '#525252',
    rule:    '#1f1f1f',
    accent:  '#9bf00b',
    chip:    '#141414',
  },
};

// goals as objects — area is a tag, weight controls visual size.
// "weight" is just how much room a goal earns on the wall.
const GOALS = [
  { area: 'Work',   weight: 'L', title: 'Ship side project v0.1', detail: 'Quiet launch, month-end' },
  { area: 'Body',   weight: 'L', title: 'Sub-25 5K',              detail: 'PB 26:14 · final weekend' },
  { area: 'Work',   weight: 'M', title: '€500 to brokerage',      detail: 'Auto-transfer set' },
  { area: 'Body',   weight: 'M', title: 'Strength 3× / week',     detail: 'Push · pull · legs' },
  { area: 'Mind',   weight: 'L', title: 'Beginning of Infinity',  detail: 'Deutsch · finish' },
  { area: 'Mind',   weight: 'S', title: 'Severance S2',           detail: 'Tue evenings' },
  { area: 'Skill',  weight: 'M', title: 'Rust ownership',         detail: 'Rust in Action ch. 4–7' },
  { area: 'Skill',  weight: 'S', title: 'Italian A2',             detail: 'Pimsleur 14–20' },
  { area: 'Skill',  weight: 'S', title: 'Tonal harmony',          detail: '15m at piano' },
  { area: 'Daily',  weight: 'M', title: 'Read 20m before bed',    detail: 'No exceptions' },
  { area: 'Daily',  weight: 'S', title: 'No phone before 9am',    detail: 'Weekdays' },
  { area: 'Daily',  weight: 'S', title: 'Cook at home 5×',        detail: '' },
  { area: 'Play',   weight: 'M', title: 'Silksong main story',    detail: '' },
  { area: 'Play',   weight: 'S', title: 'Elden DLC w/ Mark',      detail: 'Sundays' },
  { area: 'Life',   weight: 'M', title: 'Renew passport',         detail: 'Before 20th' },
  { area: 'Life',   weight: 'S', title: 'Lisbon trip',            detail: 'Book flights' },
  { area: 'Life',   weight: 'S', title: 'Tax filing',             detail: 'Due 31st' },
];

const AREA_ORDER = ['Work', 'Body', 'Mind', 'Skill', 'Daily', 'Play', 'Life'];

function Atelier() {
  const [theme, setTheme] = React.useState('light');
  const C = PALETTES[theme];
  const isDark = theme === 'dark';

  const display = '"Fraunces", "Instrument Serif", Georgia, serif';
  const sans = '"Inter", ui-sans-serif, system-ui, sans-serif';
  const mono = '"JetBrains Mono", ui-monospace, monospace';

  // group goals by area, in canonical order
  const grouped = AREA_ORDER
    .map((area) => ({ area, items: GOALS.filter((g) => g.area === area) }))
    .filter((g) => g.items.length > 0);

  return (
    <div style={{
      width: '100%', height: '100%', background: C.bg, color: C.ink,
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
      fontFamily: sans, transition: 'background .25s, color .25s',
    }}>
      {/* status */}
      <div style={{
        height: 36, padding: '0 22px', display: 'flex',
        alignItems: 'center', justifyContent: 'space-between',
        fontSize: 13, fontWeight: 600, color: C.ink, flexShrink: 0,
      }}>
        <span>9:41</span>
        <span style={{ fontSize: 11, opacity: 0.7 }}>●●●● · 86%</span>
      </div>

      {/* TOP BAR — preserved exactly as user likes it */}
      <div style={{ padding: '14px 22px 16px', flexShrink: 0 }}>
        <div style={{
          display: 'flex', justifyContent: 'space-between', alignItems: 'baseline',
          marginBottom: 14,
        }}>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
            <span style={{
              fontFamily: display, fontSize: 24, fontStyle: 'italic',
              fontWeight: 400, letterSpacing: -0.5, color: C.ink,
            }}>May</span>
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.mute,
              letterSpacing: 1.4, textTransform: 'uppercase',
            }}>2026</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
            <span style={{
              fontFamily: mono, fontSize: 10, color: C.sub,
              letterSpacing: 1.4,
            }}>
              <span style={{ color: C.ink, fontWeight: 600 }}>{daysLeft}</span>
              <span style={{ color: C.mute }}> DAYS LEFT</span>
            </span>
            <button
              onClick={() => setTheme(isDark ? 'light' : 'dark')}
              aria-label="toggle theme"
              style={{
                background: 'transparent', border: `1px solid ${C.rule}`,
                color: C.sub, width: 26, height: 26, borderRadius: 999,
                fontSize: 11, cursor: 'pointer', display: 'flex',
                alignItems: 'center', justifyContent: 'center', padding: 0,
              }}>
              {isDark ? '☼' : '☾'}
            </button>
          </div>
        </div>

        {/* tick strip */}
        <div style={{ position: 'relative', height: 14 }}>
          <div style={{
            position: 'absolute', left: 0, right: 0, top: 6,
            height: 1, background: C.rule,
          }}/>
          {Array.from({ length: MONTH.daysInMonth }).map((_, i) => {
            const day = i + 1;
            const isToday = day === dayOfMonth;
            const isMajor = day % 5 === 0 || day === 1 || day === MONTH.daysInMonth;
            return (
              <div key={i} style={{
                position: 'absolute',
                left: `${(i / (MONTH.daysInMonth - 1)) * 100}%`,
                top: 6, transform: 'translate(-50%, 0)',
                width: isToday ? 2 : 1,
                height: isToday ? 14 : (isMajor ? 6 : 3),
                background: isToday ? C.accent : C.rule,
              }}/>
            );
          })}
        </div>
      </div>

      {/* WALL — areas as gutter labels, goals as a flowing mosaic */}
      <div style={{ flex: 1, overflow: 'auto' }}>
        {grouped.map((g, gi) => (
          <AreaBand
            key={g.area} area={g.area} items={g.items}
            C={C} display={display} mono={mono} sans={sans}
            isFirst={gi === 0}
          />
        ))}
        <div style={{ height: 24 }}/>
      </div>
    </div>
  );
}

function AreaBand({ area, items, C, display, mono, sans, isFirst }) {
  return (
    <div style={{
      padding: '18px 22px 8px',
      borderTop: isFirst ? 'none' : `1px solid ${C.rule}`,
    }}>
      {/* area label — gutter style, very small */}
      <div style={{
        fontFamily: mono, fontSize: 9.5, letterSpacing: 2.4,
        textTransform: 'uppercase', color: C.mute, fontWeight: 600,
        marginBottom: 12,
        display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      }}>
        <span>{area}</span>
        <span style={{ letterSpacing: 1, opacity: 0.7 }}>
          {String(items.length).padStart(2, '0')}
        </span>
      </div>

      {/* mosaic — goals flow, sized by weight */}
      <div style={{
        display: 'flex', flexWrap: 'wrap', gap: 8,
      }}>
        {items.map((g, i) => (
          <Goal key={i} g={g} C={C}
            display={display} mono={mono} sans={sans} />
        ))}
      </div>
    </div>
  );
}

function Goal({ g, C, display, mono, sans }) {
  // weight maps to width and prominence
  const cfg = {
    L: { basis: '100%', titleSize: 19, padY: 16, padX: 16,
         detailSize: 12.5, showDetail: true },
    M: { basis: 'calc(50% - 4px)', titleSize: 15, padY: 14, padX: 14,
         detailSize: 11.5, showDetail: true },
    S: { basis: 'calc(50% - 4px)', titleSize: 13, padY: 11, padX: 12,
         detailSize: 10.5, showDetail: false },
  }[g.weight];

  return (
    <div style={{
      flex: `1 1 ${cfg.basis}`,
      minWidth: g.weight === 'L' ? '100%' : 'calc(50% - 4px)',
      maxWidth: g.weight === 'L' ? '100%' : '100%',
      padding: `${cfg.padY}px ${cfg.padX}px`,
      background: C.chip,
      border: `1px solid ${C.rule}`,
      borderRadius: 14,
      display: 'flex', flexDirection: 'column', justifyContent: 'space-between',
      gap: 6, minHeight: g.weight === 'S' ? 64 : (g.weight === 'M' ? 84 : 96),
    }}>
      <div style={{
        fontFamily: display, fontSize: cfg.titleSize, fontWeight: 400,
        letterSpacing: -0.3, lineHeight: 1.2, color: C.ink,
      }}>{g.title}</div>
      {cfg.showDetail && g.detail && (
        <div style={{
          fontFamily: sans, fontSize: cfg.detailSize, color: C.sub,
          fontWeight: 400, lineHeight: 1.4,
        }}>{g.detail}</div>
      )}
      {!cfg.showDetail && g.detail && (
        <div style={{
          fontFamily: mono, fontSize: 9, color: C.mute,
          letterSpacing: 1, textTransform: 'uppercase',
        }}>{g.detail}</div>
      )}
    </div>
  );
}

window.Atelier = Atelier;
