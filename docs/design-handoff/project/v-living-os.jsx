// Living OS — month dashboard styled as a personal operating system.
// Hero "live" tile with breathing time-of-month indicator, ambient
// rings showing month progress, soft layered surfaces, focal areas
// instead of a list. Goals are domains, not tasks.

const T_BG = '#0c0d11';
const T_BG_HI = '#11131a';
const T_SURF = '#171a23';
const T_SURF_HI = '#1d2130';
const T_LINE = '#222633';
const T_FG = '#f5f6fa';
const T_DIM = '#9aa0b3';
const T_LO = '#5c6378';
const T_PULSE = '#c5fb6e';

const DOMAINS = [
  { key: 'achieve',  label: 'Ambitions',   tint: '#fbbf24', glyph: '◇',
    headline: 'Run a sub-25 5K',         under: 'PB now 26:14 · target by 31 May' },
  { key: 'learn',    label: 'Studies',     tint: '#7dd3fc', glyph: '✦',
    headline: 'Rust ownership',          under: 'Rust in Action · ch. 4–7' },
  { key: 'health',   label: 'Body',        tint: '#f9a8d4', glyph: '❋',
    headline: 'Strength · 3× / week',    under: 'Push · pull · legs' },
  { key: 'routines', label: 'Rhythms',     tint: '#86efac', glyph: '◐',
    headline: 'Read 20 min before bed',  under: 'Daily, no exceptions' },
  { key: 'games',    label: 'Play',        tint: '#c4b5fd', glyph: '◈',
    headline: 'Silksong · main story',   under: 'Sundays w/ Mark on Elden DLC' },
  { key: 'media',    label: 'Mind',        tint: '#67e8f9', glyph: '❖',
    headline: 'Beginning of Infinity',   under: 'Deutsch · finish' },
  { key: 'actions',  label: 'Errands',     tint: '#fdba74', glyph: '△',
    headline: 'Renew passport',          under: 'Before May 20 · also tax filing' },
  { key: 'free',     label: 'Open',        tint: '#cbd5e1', glyph: '○',
    headline: 'Plan trip to Lisbon',     under: 'Book flights this week' },
];

function LivingOS() {
  const pct = monthProgress;
  return (
    <div style={{
      width: '100%', height: '100%', color: T_FG,
      background: `radial-gradient(120% 60% at 50% 0%, #1a1f2e 0%, ${T_BG} 55%)`,
      fontFamily: '"Inter", ui-sans-serif, system-ui, sans-serif',
      display: 'flex', flexDirection: 'column', overflow: 'hidden',
    }}>
      {/* status */}
      <div style={{
        height: 36, padding: '0 22px', display: 'flex',
        alignItems: 'center', justifyContent: 'space-between',
        fontSize: 13, fontWeight: 600,
      }}>
        <span>9:41</span>
        <span style={{ fontSize: 11, opacity: 0.8 }}>●●●● · 86%</span>
      </div>

      {/* live header tile */}
      <div style={{ padding: '4px 18px 14px' }}>
        <div style={{
          position: 'relative', overflow: 'hidden',
          background: T_BG_HI, borderRadius: 22,
          border: `1px solid ${T_LINE}`,
          padding: '18px 18px 16px',
        }}>
          {/* ambient ring */}
          <svg width="120" height="120" viewBox="0 0 120 120"
            style={{ position: 'absolute', right: -24, top: -24, opacity: 0.9 }}>
            <circle cx="60" cy="60" r="50" stroke={T_LINE}
              strokeWidth="1" fill="none"/>
            <circle cx="60" cy="60" r="50" stroke={T_PULSE}
              strokeWidth="1.5" fill="none"
              strokeDasharray={`${2 * Math.PI * 50 * pct} ${2 * Math.PI * 50}`}
              transform="rotate(-90 60 60)" strokeLinecap="round"/>
            <circle cx="60" cy="60" r="38" stroke={T_LINE}
              strokeWidth="1" fill="none" opacity="0.6"/>
          </svg>

          <div style={{
            fontSize: 10, fontWeight: 700, letterSpacing: 2.5,
            color: T_DIM, textTransform: 'uppercase',
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <span style={{ width: 6, height: 6, borderRadius: 3, background: T_PULSE,
              boxShadow: `0 0 10px ${T_PULSE}` }}/>
            Live · May 2026
          </div>
          <div style={{
            fontSize: 36, fontWeight: 600, letterSpacing: -1,
            marginTop: 8, lineHeight: 1.05,
          }}>
            Day <span style={{ color: T_PULSE }}>{dayOfMonth}</span>
            <span style={{ color: T_LO, fontWeight: 400 }}> / {MONTH.daysInMonth}</span>
          </div>
          <div style={{ display: 'flex', alignItems: 'baseline', gap: 8,
            marginTop: 4, color: T_DIM, fontSize: 13, fontWeight: 500 }}>
            <span style={{ color: T_FG, fontWeight: 600 }}>{daysLeft}</span>
            <span>days to honour what you set</span>
          </div>

          {/* horizontal day strip */}
          <div style={{ marginTop: 14, height: 22, position: 'relative' }}>
            <div style={{
              position: 'absolute', inset: 0, display: 'flex', gap: 1.5,
            }}>
              {Array.from({ length: MONTH.daysInMonth }).map((_, i) => {
                const past = i < dayOfMonth - 1;
                const today = i === dayOfMonth - 1;
                return (
                  <div key={i} style={{
                    flex: 1, borderRadius: 1,
                    background: today ? T_PULSE : (past ? T_DIM : T_LINE),
                    height: today ? 22 : (past ? 8 : 4),
                    alignSelf: 'flex-end',
                    boxShadow: today ? `0 0 8px ${T_PULSE}` : 'none',
                  }}/>
                );
              })}
            </div>
          </div>
        </div>
      </div>

      {/* domains */}
      <div style={{ flex: 1, overflow: 'auto', padding: '0 18px 24px' }}>
        <div style={{
          display: 'flex', alignItems: 'center', gap: 8, marginBottom: 12,
          fontSize: 10, color: T_LO, fontWeight: 700, letterSpacing: 2,
          textTransform: 'uppercase',
        }}>
          <span style={{ flex: 1, height: 1, background: T_LINE }}/>
          <span>Domains</span>
          <span style={{ flex: 1, height: 1, background: T_LINE }}/>
        </div>

        {/* feature row — first domain large */}
        <DomainCard d={DOMAINS[0]} feature />

        {/* 2-col grid for remaining */}
        <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr',
          gap: 8, marginTop: 8 }}>
          {DOMAINS.slice(1).map((d) => <DomainCard key={d.key} d={d} />)}
        </div>

        <div style={{
          marginTop: 18, padding: '12px 14px',
          background: T_SURF, borderRadius: 14,
          border: `1px solid ${T_LINE}`,
          fontSize: 12, color: T_DIM, lineHeight: 1.5,
        }}>
          <span style={{ color: T_FG, fontWeight: 600 }}>{TOTAL_COUNT} commitments</span>
          {' '}across {DOMAINS.length} domains. The shape of a quiet,
          building month.
        </div>
      </div>
    </div>
  );
}

function DomainCard({ d, feature }) {
  return (
    <div style={{
      gridColumn: feature ? 'span 2' : 'auto',
      position: 'relative', overflow: 'hidden',
      background: T_SURF, borderRadius: 16,
      padding: feature ? '16px 18px' : 14,
      border: `1px solid ${T_LINE}`,
      borderLeft: `3px solid ${d.tint}`,
    }}>
      <div style={{
        display: 'flex', alignItems: 'center', gap: 8, marginBottom: 6,
      }}>
        <span style={{ fontSize: 13, color: d.tint, lineHeight: 1 }}>{d.glyph}</span>
        <span style={{
          fontSize: 10, fontWeight: 700, letterSpacing: 1.6,
          textTransform: 'uppercase', color: d.tint,
        }}>{d.label}</span>
      </div>
      <div style={{
        fontSize: feature ? 19 : 14, fontWeight: 600,
        letterSpacing: -0.3, lineHeight: 1.25, color: T_FG,
      }}>{d.headline}</div>
      <div style={{
        fontSize: feature ? 13 : 11, color: T_DIM,
        marginTop: 4, lineHeight: 1.4, fontWeight: 400,
      }}>{d.under}</div>
    </div>
  );
}

window.LivingOS = LivingOS;
