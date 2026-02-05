import { Artist } from "./Artist";

/**
 * Track Domain Entity
 */
export interface TrackAlbum {
  id: string;
  title: string;
}

export interface Track {
  id: string;
  title: string;
  coverUrl: string | null;
  trackUrl: string | null;
  duration: number;
  album?: TrackAlbum | null;
  artists?: Artist[];
}

export class TrackEntity implements Track {
  constructor(
    public readonly id: string,
    public readonly title: string,
    public readonly coverUrl: string | null,
    public readonly trackUrl: string | null,
    public readonly duration: number,
    public readonly album: TrackAlbum | null = null,
    public readonly artists: Artist[] = [],
  ) {}

  static create(props: Track): TrackEntity {
    return new TrackEntity(
      props.id,
      props.title,
      props.coverUrl,
      props.trackUrl,
      props.duration,
      props.album || null,
      props.artists || [],
    );
  }
}
