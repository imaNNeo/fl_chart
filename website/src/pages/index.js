import React, {useEffect, useRef, useState} from 'react';
import clsx from 'clsx';
import Link from '@docusaurus/Link';
import {useBaseUrlUtils} from '@docusaurus/useBaseUrl';
import Layout from '@theme/Layout';

import ChartMorph from '@site/src/components/ChartMorph';
import styles from './index.module.css';

const INSTALL = 'flutter pub add fl_chart';

const GAMES = [
  {
    title: 'Save the Potato',
    pitch: 'Keep the orbs away so the potato can enjoy its music in peace.',
    image: '/img/games/save_the_potato.jpg',
    href: 'https://savethepotato.com/get/?utm_source=fl_chart&utm_medium=website',
  },
  {
    title: 'TTG - Through The Galaxies',
    pitch: 'Fly your rocket from planet to planet and see how far into space you can go.',
    image: '/img/games/ttg.jpg',
    href: 'https://ttg.app2pack.dev/get/?utm_source=fl_chart&utm_medium=website',
  },
];

const iconProps = {
  viewBox: '0 0 24 24',
  fill: 'none',
  stroke: 'currentColor',
  strokeLinecap: 'round',
  strokeLinejoin: 'round',
  'aria-hidden': true,
};

function InstallCommand() {
  const [copied, setCopied] = useState(false);
  const timer = useRef(0);
  useEffect(() => () => clearTimeout(timer.current), []);

  const copy = async () => {
    try {
      await navigator.clipboard.writeText(INSTALL);
    } catch {
      return;
    }
    setCopied(true);
    clearTimeout(timer.current);
    timer.current = setTimeout(() => setCopied(false), 1400);
  };

  return (
    <div>
      <button
        type="button"
        className={clsx(styles.install, copied && styles.copied)}
        onClick={copy}
        aria-label={`Copy the install command: ${INSTALL}`}>
        <span>
          <span className={styles.prompt}>$</span> {INSTALL}
        </span>
        <span className={styles.copyState}>
          {copied ? (
            <svg {...iconProps} strokeWidth="2.4" width="15" height="15">
              <path d="M5 12.5l4.5 4.5L19 7.5" />
            </svg>
          ) : (
            <svg {...iconProps} strokeWidth="2" width="15" height="15">
              <rect x="9" y="9" width="12" height="12" rx="2" />
              <path d="M5 15H4a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h10a1 1 0 0 1 1 1v1" />
            </svg>
          )}
        </span>
      </button>
      <span className={styles.visuallyHidden} role="status">
        {copied ? 'Copied' : ''}
      </span>
    </div>
  );
}

export default function Home() {
  const {withBaseUrl} = useBaseUrlUtils();
  return (
    <Layout description="A highly customizable Flutter chart library: line, bar, candlestick, scatter, radar, pie and gauge charts, free and open source.">
      <main className={styles.hero}>
        <div className={styles.copy}>
          <span className={styles.eyebrow}>
            <img src={withBaseUrl('/img/flutter.svg')} alt="" width="15" height="18" />
            Flutter chart library
          </span>
          <h1 className={styles.title}>
            Endless <b>Customizability</b>
            <br />
            Forever <b>Free</b>
          </h1>
          <p className={styles.sub}>
            Line, bar, candlestick, scatter, radar, pie and gauge charts. Change
            the data and they animate to it.
          </p>
          <div className={styles.actions}>
            <Link className={clsx(styles.button, styles.solid)} to="/docs">
              Get started
            </Link>
            <Link className={clsx(styles.button, styles.ghost)} href="https://app.flchart.dev/">
              Examples app
              <img src={withBaseUrl('/img/play_arrow.svg')} alt="" width="15" height="15" />
            </Link>
          </div>
          <InstallCommand />
        </div>

        <ChartMorph className={styles.widget} />

        <section className={styles.support} aria-label="Support fl_chart">
          <p className={styles.supportLabel}>Support fl_chart by playing my games:</p>
          {GAMES.map((game) => (
            <Link key={game.title} className={styles.game} href={game.href}>
              <img src={withBaseUrl(game.image)} alt={game.title} width="104" height="51" />
              <span className={styles.gameText}>
                <span className={styles.gameTitle}>{game.title}</span>
                <span className={styles.gamePitch}>{game.pitch}</span>
                <span className={styles.gamePlay}>Free on Android and iOS ▶</span>
              </span>
            </Link>
          ))}
          <Link className={styles.mail} href="https://iman-khoshabi.kit.com/profile">
            <svg {...iconProps} strokeWidth="1.8" width="16" height="16">
              <rect x="3" y="5" width="18" height="14" rx="2" />
              <path d="M3.5 6.5l8.5 6.5 8.5-6.5" />
            </svg>
            Get an email when I release a new game
          </Link>
        </section>
      </main>
    </Layout>
  );
}
