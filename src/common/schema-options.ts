export const jsonTransform = (_doc: unknown, ret: Record<string, unknown>) => {
  ret.id = (ret._id as { toString(): string })?.toString();
  delete ret._id;
  delete ret.__v;
  return ret;
};

export const defaultSchemaOptions = {
  timestamps: true,
  toJSON: { virtuals: true, versionKey: false, transform: jsonTransform },
  toObject: { virtuals: true, versionKey: false, transform: jsonTransform },
};
