import { Artist } from "./Artist";
import { Track } from "./Track";

/**
 * Album Domain Entity
 */
export interface Album {
  id: string;
  title: string;
  coverUrl: string | null;
  tracks?: Track[];
  artists?: Artist[];
}

export class AlbumEntity implements Album {
  constructor(
    public readonly id: string,
    public readonly title: string,
    public readonly coverUrl: string | null,
    public readonly tracks: Track[] = [],
    public readonly artists: Artist[] = [],
  ) {}

  static create(props: Album): AlbumEntity {
    return new AlbumEntity(
      props.id,
      props.title,
      props.coverUrl,
      props.tracks || [],
      props.artists || [],
    );
  }
}
